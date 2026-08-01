! SPDX-License-Identifier: MIT
program write_json
  use, intrinsic :: iso_c_binding
  use yyjson_module
  implicit none

  type(json_mut_document) :: doc
  type(json_mut_value) :: root, hits
  character(len=:), allocatable :: text

  call doc%init()

  root = doc%new_object()
  call doc%object_add_string(root, "name", "Mash")
  call doc%object_add_integer(root, "star", 4_c_int64_t)

  hits = doc%new_array()
  call doc%array_add_integer(hits, 2_c_int64_t)
  call doc%array_add_integer(hits, 2_c_int64_t)
  call doc%array_add_integer(hits, 1_c_int64_t)
  call doc%array_add_integer(hits, 3_c_int64_t)
  call doc%object_add(root, "hits", hits)

  call doc%set_root(root)

  text = doc%to_chars()
  write (*, '(A)') text

  text = doc%to_chars(pretty=.true.)
  write (*, '(A)') text

  call doc%destroy()
end program write_json
