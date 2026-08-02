! SPDX-License-Identifier: MIT
program mutate_json
  use, intrinsic :: iso_c_binding
  use yyjson_module
  implicit none

  type(json_document) :: doc
  type(json_value) :: root
  type(json_object_iterator) :: obj_it
  type(json_value) :: field_val
  character(len=:), allocatable :: key, text

  type(json_mut_document) :: out_doc
  type(json_mut_value) :: out_root

  doc = json_parse('{"name":"Mash","star":4,"active":true}')
  root = doc%root()

  call out_doc%init()
  out_root = out_doc%new_object()

  obj_it = root%object_iterator()
  do while (obj_it%has_next())
    field_val = obj_it%next(key)

    if (field_val%is_string()) then
      call out_doc%object_add_string(out_root, key, field_val%to_chars())
    else if (field_val%is_integer()) then
      call out_doc%object_add_integer(out_root, key, field_val%to_integer())
    else if (field_val%is_bool()) then
      call out_doc%object_add_bool(out_root, key, field_val%to_logical())
    end if
  end do

  call out_doc%object_add_string(out_root, "note", "processed by fortran-yyjson")
  call out_doc%set_root(out_root)

  text = out_doc%to_chars(pretty=.true.)
  write (*, '(A)') text

  call out_doc%destroy()
  call doc%destroy()
end program mutate_json
