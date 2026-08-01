! SPDX-License-Identifier: MIT
program read_json
  use, intrinsic :: iso_c_binding
  use yyjson_module
  implicit none

  type(json_document) :: doc
  type(json_value) :: root, name_val, star_val, hits, hit
  type(json_array_iterator) :: it
  integer :: i

  doc = json_parse('{"name":"Mash","star":4,"hits":[2,2,1,3]}')

  if (.not. doc%is_valid()) then
    write (*, '(A)') "Failed to parse JSON"
    stop 1
  end if

  root = doc%root()

  name_val = root%object_get("name")
  write (*, '(A,A)') "name: ", name_val%to_chars()

  star_val = root%object_get("star")
  write (*, '(A,I0)') "star: ", int(star_val%to_integer())

  hits = root%object_get("hits")
  it = hits%array_iterator()
  i = 0
  do while (it%has_next())
    hit = it%next()
    write (*, '(A,I0,A,I0)') "hit", i, ": ", int(hit%to_integer())
    i = i + 1
  end do

  call doc%destroy()
end program read_json
