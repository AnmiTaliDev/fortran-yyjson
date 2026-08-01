! SPDX-License-Identifier: MIT
program test_yyjson
  use, intrinsic :: iso_c_binding
  use yyjson_module
  implicit none

  integer :: failures

  failures = 0

  call test_parse_scalar(failures)
  call test_parse_object(failures)
  call test_parse_array(failures)
  call test_parse_nested(failures)
  call test_array_iterator(failures)
  call test_object_iterator(failures)
  call test_invalid_json(failures)
  call test_write_roundtrip(failures)
  call test_mut_build_object(failures)
  call test_mut_build_array(failures)
  call test_mut_nested(failures)

  if (failures /= 0) then
    write (*, '(A,I0,A)') "FAILED: ", failures, " test(s) failed"
    stop 1
  else
    write (*, '(A)') "All tests passed"
  end if

contains

  subroutine check(cond, name, failures)
    logical, intent(in) :: cond
    character(len=*), intent(in) :: name
    integer, intent(inout) :: failures
    if (cond) then
      write (*, '(A,A)') "  ok   - ", name
    else
      write (*, '(A,A)') "  FAIL - ", name
      failures = failures + 1
    end if
  end subroutine check

  subroutine test_parse_scalar(failures)
    integer, intent(inout) :: failures
    type(json_document) :: doc
    type(json_value) :: root

    doc = json_parse("42")
    call check(doc%is_valid(), "parse_scalar: document valid", failures)
    root = doc%root()
    call check(root%is_number(), "parse_scalar: root is number", failures)
    call check(root%to_integer() == 42_c_int64_t, "parse_scalar: value equals 42", failures)
    call doc%destroy()
  end subroutine test_parse_scalar

  subroutine test_parse_object(failures)
    integer, intent(inout) :: failures
    type(json_document) :: doc
    type(json_value) :: root, name_val, star_val

    doc = json_parse('{"name":"Mash","star":4}')
    call check(doc%is_valid(), "parse_object: document valid", failures)
    root = doc%root()
    call check(root%is_object(), "parse_object: root is object", failures)
    call check(root%object_size() == 2_c_size_t, "parse_object: size is 2", failures)

    name_val = root%object_get("name")
    call check(name_val%is_string(), "parse_object: name is string", failures)
    call check(name_val%to_chars() == "Mash", "parse_object: name equals Mash", failures)

    star_val = root%object_get("star")
    call check(star_val%is_integer(), "parse_object: star is integer", failures)
    call check(star_val%to_integer() == 4_c_int64_t, "parse_object: star equals 4", failures)

    call doc%destroy()
  end subroutine test_parse_object

  subroutine test_parse_array(failures)
    integer, intent(inout) :: failures
    type(json_document) :: doc
    type(json_value) :: root, item

    doc = json_parse("[2,2,1,3]")
    root = doc%root()
    call check(root%is_array(), "parse_array: root is array", failures)
    call check(root%array_size() == 4_c_size_t, "parse_array: size is 4", failures)

    item = root%array_get(0)
    call check(item%to_integer() == 2_c_int64_t, "parse_array: item 0 equals 2", failures)
    item = root%array_get(2)
    call check(item%to_integer() == 1_c_int64_t, "parse_array: item 2 equals 1", failures)

    call doc%destroy()
  end subroutine test_parse_array

  subroutine test_parse_nested(failures)
    integer, intent(inout) :: failures
    type(json_document) :: doc
    type(json_value) :: root, hits, hit0

    doc = json_parse('{"name":"Mash","star":4,"hits":[2,2,1,3]}')
    root = doc%root()
    hits = root%object_get("hits")
    call check(hits%is_array(), "parse_nested: hits is array", failures)
    call check(hits%array_size() == 4_c_size_t, "parse_nested: hits size is 4", failures)
    hit0 = hits%array_get(0)
    call check(hit0%to_integer() == 2_c_int64_t, "parse_nested: hits[0] equals 2", failures)

    call doc%destroy()
  end subroutine test_parse_nested

  subroutine test_array_iterator(failures)
    integer, intent(inout) :: failures
    type(json_document) :: doc
    type(json_value) :: root, item
    type(json_array_iterator) :: it
    integer :: total, count

    doc = json_parse("[1,2,3,4,5]")
    root = doc%root()
    it = root%array_iterator()

    total = 0
    count = 0
    do while (it%has_next())
      item = it%next()
      total = total + int(item%to_integer())
      count = count + 1
    end do

    call check(count == 5, "array_iterator: visited 5 items", failures)
    call check(total == 15, "array_iterator: sum equals 15", failures)

    call doc%destroy()
  end subroutine test_array_iterator

  subroutine test_object_iterator(failures)
    integer, intent(inout) :: failures
    type(json_document) :: doc
    type(json_value) :: root, val
    type(json_object_iterator) :: it
    character(len=:), allocatable :: key
    integer :: count

    doc = json_parse('{"a":1,"b":2,"c":3}')
    root = doc%root()
    it = root%object_iterator()

    count = 0
    do while (it%has_next())
      val = it%next(key)
      count = count + 1
    end do

    call check(count == 3, "object_iterator: visited 3 members", failures)

    call doc%destroy()
  end subroutine test_object_iterator

  subroutine test_invalid_json(failures)
    integer, intent(inout) :: failures
    type(json_document) :: doc

    doc = json_parse("{not valid json")
    call check(.not. doc%is_valid(), "invalid_json: document is invalid", failures)
  end subroutine test_invalid_json

  subroutine test_write_roundtrip(failures)
    integer, intent(inout) :: failures
    type(json_document) :: doc
    character(len=:), allocatable :: text

    doc = json_parse('{"a":1,"b":[1,2,3]}')
    text = doc%to_chars()
    call check(len(text) > 0, "write_roundtrip: text is non-empty", failures)
    call doc%destroy()

    doc = json_parse(text)
    call check(doc%is_valid(), "write_roundtrip: reparsed document valid", failures)
    call doc%destroy()
  end subroutine test_write_roundtrip

  subroutine test_mut_build_object(failures)
    integer, intent(inout) :: failures
    type(json_mut_document) :: doc
    type(json_mut_value) :: root
    character(len=:), allocatable :: text
    type(json_document) :: parsed
    type(json_value) :: proot

    call doc%init()
    root = doc%new_object()
    call doc%object_add_string(root, "name", "Mash")
    call doc%object_add_integer(root, "star", 4_c_int64_t)
    call doc%object_add_bool(root, "active", .true.)
    call doc%set_root(root)

    text = doc%to_chars()
    call check(len(text) > 0, "mut_build_object: text non-empty", failures)

    parsed = json_parse(text)
    call check(parsed%is_valid(), "mut_build_object: output re-parses", failures)
    proot = parsed%root()
    block
      type(json_value) :: name_val, star_val
      name_val = proot%object_get("name")
      star_val = proot%object_get("star")
      call check(name_val%to_chars() == "Mash", &
                 "mut_build_object: name round-trips", failures)
      call check(star_val%to_integer() == 4_c_int64_t, &
                 "mut_build_object: star round-trips", failures)
    end block

    call parsed%destroy()
    call doc%destroy()
  end subroutine test_mut_build_object

  subroutine test_mut_build_array(failures)
    integer, intent(inout) :: failures
    type(json_mut_document) :: doc
    type(json_mut_value) :: root
    character(len=:), allocatable :: text
    type(json_document) :: parsed
    type(json_value) :: proot

    call doc%init()
    root = doc%new_array()
    call doc%array_add_integer(root, 10_c_int64_t)
    call doc%array_add_integer(root, 20_c_int64_t)
    call doc%array_add_integer(root, 30_c_int64_t)
    call doc%set_root(root)

    text = doc%to_chars()
    parsed = json_parse(text)
    proot = parsed%root()
    call check(proot%is_array(), "mut_build_array: parsed root is array", failures)
    call check(proot%array_size() == 3_c_size_t, "mut_build_array: size is 3", failures)
    block
      type(json_value) :: item1
      item1 = proot%array_get(1)
      call check(item1%to_integer() == 20_c_int64_t, &
                 "mut_build_array: item 1 equals 20", failures)
    end block

    call parsed%destroy()
    call doc%destroy()
  end subroutine test_mut_build_array

  subroutine test_mut_nested(failures)
    integer, intent(inout) :: failures
    type(json_mut_document) :: doc
    type(json_mut_value) :: root, hits
    character(len=:), allocatable :: text
    type(json_document) :: parsed
    type(json_value) :: proot, phits

    call doc%init()
    root = doc%new_object()
    hits = doc%new_array()
    call doc%array_add_integer(hits, 2_c_int64_t)
    call doc%array_add_integer(hits, 2_c_int64_t)
    call doc%array_add_integer(hits, 1_c_int64_t)
    call doc%object_add(root, "hits", hits)
    call doc%object_add_string(root, "name", "Mash")
    call doc%set_root(root)

    text = doc%to_chars()
    parsed = json_parse(text)
    proot = parsed%root()
    phits = proot%object_get("hits")
    call check(phits%is_array(), "mut_nested: hits is array", failures)
    call check(phits%array_size() == 3_c_size_t, "mut_nested: hits size is 3", failures)

    call parsed%destroy()
    call doc%destroy()
  end subroutine test_mut_nested

end program test_yyjson
