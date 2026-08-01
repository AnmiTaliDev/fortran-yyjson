! SPDX-License-Identifier: MIT
module yyjson_capi
  use, intrinsic :: iso_c_binding
  implicit none
  private

  public :: c_yyjson_read
  public :: c_yyjson_read_opts
  public :: c_yyjson_doc_free
  public :: c_yyjson_doc_get_root
  public :: c_yyjson_write
  public :: c_yyjson_write_opts
  public :: c_free

  public :: c_yyjson_get_type
  public :: c_yyjson_get_subtype
  public :: c_yyjson_get_type_desc
  public :: c_yyjson_is_null
  public :: c_yyjson_is_true
  public :: c_yyjson_is_false
  public :: c_yyjson_is_bool
  public :: c_yyjson_is_num
  public :: c_yyjson_is_int
  public :: c_yyjson_is_uint
  public :: c_yyjson_is_sint
  public :: c_yyjson_is_real
  public :: c_yyjson_is_str
  public :: c_yyjson_is_arr
  public :: c_yyjson_is_obj
  public :: c_yyjson_is_ctn

  public :: c_yyjson_get_bool
  public :: c_yyjson_get_sint
  public :: c_yyjson_get_uint
  public :: c_yyjson_get_real
  public :: c_yyjson_get_num
  public :: c_yyjson_get_str
  public :: c_yyjson_get_len

  public :: c_yyjson_arr_size
  public :: c_yyjson_arr_get
  public :: c_yyjson_arr_get_first
  public :: c_yyjson_arr_get_last
  public :: c_yyjson_arr_iter_with
  public :: c_yyjson_arr_iter_next

  public :: c_yyjson_obj_size
  public :: c_yyjson_obj_get
  public :: c_yyjson_obj_getn
  public :: c_yyjson_obj_iter_with
  public :: c_yyjson_obj_iter_next
  public :: c_yyjson_obj_iter_get_val

  public :: c_yyjson_mut_doc_new
  public :: c_yyjson_mut_doc_free
  public :: c_yyjson_mut_doc_set_root
  public :: c_yyjson_mut_doc_get_root
  public :: c_yyjson_mut_write
  public :: c_yyjson_mut_write_opts

  public :: c_yyjson_mut_null
  public :: c_yyjson_mut_true
  public :: c_yyjson_mut_false
  public :: c_yyjson_mut_bool
  public :: c_yyjson_mut_sint
  public :: c_yyjson_mut_uint
  public :: c_yyjson_mut_real
  public :: c_yyjson_mut_str
  public :: c_yyjson_mut_strn
  public :: c_yyjson_mut_strcpy
  public :: c_yyjson_mut_strncpy

  public :: c_yyjson_mut_arr
  public :: c_yyjson_mut_arr_add_val
  public :: c_yyjson_mut_arr_add_null
  public :: c_yyjson_mut_arr_add_bool
  public :: c_yyjson_mut_arr_add_sint
  public :: c_yyjson_mut_arr_add_uint
  public :: c_yyjson_mut_arr_add_real
  public :: c_yyjson_mut_arr_add_str
  public :: c_yyjson_mut_arr_add_strn

  public :: c_yyjson_mut_obj
  public :: c_yyjson_mut_obj_add_val
  public :: c_yyjson_mut_obj_add_null
  public :: c_yyjson_mut_obj_add_bool
  public :: c_yyjson_mut_obj_add_sint
  public :: c_yyjson_mut_obj_add_uint
  public :: c_yyjson_mut_obj_add_real
  public :: c_yyjson_mut_obj_add_str
  public :: c_yyjson_mut_obj_add_strn

  public :: c_yyjson_mut_val_mut_copy
  public :: c_yyjson_val_mut_copy

  public :: yyjson_read_flag_t
  public :: yyjson_write_flag_t

  integer(c_int), parameter :: yyjson_read_flag_t = c_int
  integer(c_int), parameter :: yyjson_write_flag_t = c_int

  type, public, bind(c) :: yyjson_read_err_c
    integer(c_int) :: code
    type(c_ptr)     :: msg
    integer(c_size_t) :: pos
  end type yyjson_read_err_c

  type, public, bind(c) :: yyjson_write_err_c
    integer(c_int) :: code
    type(c_ptr)     :: msg
  end type yyjson_write_err_c

  type, public, bind(c) :: yyjson_arr_iter_c
    integer(c_size_t) :: idx
    integer(c_size_t) :: max
    type(c_ptr)         :: cur
  end type yyjson_arr_iter_c

  type, public, bind(c) :: yyjson_obj_iter_c
    integer(c_size_t) :: idx
    integer(c_size_t) :: max
    type(c_ptr)         :: cur
    type(c_ptr)         :: obj
  end type yyjson_obj_iter_c

  interface

    function c_yyjson_read(dat, len, flg) bind(c, name="fy_yyjson_read") result(doc)
      import :: c_ptr, c_char, c_size_t, c_int
      character(kind=c_char), dimension(*), intent(in) :: dat
      integer(c_size_t), value :: len
      integer(c_int), value :: flg
      type(c_ptr) :: doc
    end function c_yyjson_read

    function c_yyjson_read_opts(dat, len, flg, alc, err) bind(c, name="fy_yyjson_read_opts") result(doc)
      import :: c_ptr, c_char, c_size_t, c_int
      type(c_ptr), value :: dat
      integer(c_size_t), value :: len
      integer(c_int), value :: flg
      type(c_ptr), value :: alc
      type(c_ptr), value :: err
      type(c_ptr) :: doc
    end function c_yyjson_read_opts

    subroutine c_yyjson_doc_free(doc) bind(c, name="fy_yyjson_doc_free")
      import :: c_ptr
      type(c_ptr), value :: doc
    end subroutine c_yyjson_doc_free

    function c_yyjson_doc_get_root(doc) bind(c, name="fy_yyjson_doc_get_root") result(val)
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr) :: val
    end function c_yyjson_doc_get_root

    function c_yyjson_write(doc, flg, len) bind(c, name="fy_yyjson_write") result(str)
      import :: c_ptr, c_int, c_size_t
      type(c_ptr), value :: doc
      integer(c_int), value :: flg
      type(c_ptr), value :: len
      type(c_ptr) :: str
    end function c_yyjson_write

    function c_yyjson_write_opts(doc, flg, alc, len, err) bind(c, name="fy_yyjson_write_opts") result(str)
      import :: c_ptr, c_int, c_size_t
      type(c_ptr), value :: doc
      integer(c_int), value :: flg
      type(c_ptr), value :: alc
      type(c_ptr), value :: len
      type(c_ptr), value :: err
      type(c_ptr) :: str
    end function c_yyjson_write_opts

    subroutine c_free(ptr) bind(c, name="free")
      import :: c_ptr
      type(c_ptr), value :: ptr
    end subroutine c_free

    function c_yyjson_get_type(val) bind(c, name="fy_yyjson_get_type") result(t)
      import :: c_ptr, c_int
      type(c_ptr), value :: val
      integer(c_int) :: t
    end function c_yyjson_get_type

    function c_yyjson_get_subtype(val) bind(c, name="fy_yyjson_get_subtype") result(t)
      import :: c_ptr, c_int
      type(c_ptr), value :: val
      integer(c_int) :: t
    end function c_yyjson_get_subtype

    function c_yyjson_get_type_desc(val) bind(c, name="fy_yyjson_get_type_desc") result(str)
      import :: c_ptr
      type(c_ptr), value :: val
      type(c_ptr) :: str
    end function c_yyjson_get_type_desc

    function c_yyjson_is_null(val) bind(c, name="fy_yyjson_is_null") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_null

    function c_yyjson_is_true(val) bind(c, name="fy_yyjson_is_true") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_true

    function c_yyjson_is_false(val) bind(c, name="fy_yyjson_is_false") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_false

    function c_yyjson_is_bool(val) bind(c, name="fy_yyjson_is_bool") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_bool

    function c_yyjson_is_num(val) bind(c, name="fy_yyjson_is_num") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_num

    function c_yyjson_is_int(val) bind(c, name="fy_yyjson_is_int") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_int

    function c_yyjson_is_uint(val) bind(c, name="fy_yyjson_is_uint") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_uint

    function c_yyjson_is_sint(val) bind(c, name="fy_yyjson_is_sint") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_sint

    function c_yyjson_is_real(val) bind(c, name="fy_yyjson_is_real") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_real

    function c_yyjson_is_str(val) bind(c, name="fy_yyjson_is_str") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_str

    function c_yyjson_is_arr(val) bind(c, name="fy_yyjson_is_arr") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_arr

    function c_yyjson_is_obj(val) bind(c, name="fy_yyjson_is_obj") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_obj

    function c_yyjson_is_ctn(val) bind(c, name="fy_yyjson_is_ctn") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_is_ctn

    function c_yyjson_get_bool(val) bind(c, name="fy_yyjson_get_bool") result(r)
      import :: c_ptr, c_bool
      type(c_ptr), value :: val
      logical(c_bool) :: r
    end function c_yyjson_get_bool

    function c_yyjson_get_sint(val) bind(c, name="fy_yyjson_get_sint") result(r)
      import :: c_ptr, c_int64_t
      type(c_ptr), value :: val
      integer(c_int64_t) :: r
    end function c_yyjson_get_sint

    function c_yyjson_get_uint(val) bind(c, name="fy_yyjson_get_uint") result(r)
      import :: c_ptr, c_int64_t
      type(c_ptr), value :: val
      integer(c_int64_t) :: r
    end function c_yyjson_get_uint

    function c_yyjson_get_real(val) bind(c, name="fy_yyjson_get_real") result(r)
      import :: c_ptr, c_double
      type(c_ptr), value :: val
      real(c_double) :: r
    end function c_yyjson_get_real

    function c_yyjson_get_num(val) bind(c, name="fy_yyjson_get_num") result(r)
      import :: c_ptr, c_double
      type(c_ptr), value :: val
      real(c_double) :: r
    end function c_yyjson_get_num

    function c_yyjson_get_str(val) bind(c, name="fy_yyjson_get_str") result(str)
      import :: c_ptr
      type(c_ptr), value :: val
      type(c_ptr) :: str
    end function c_yyjson_get_str

    function c_yyjson_get_len(val) bind(c, name="fy_yyjson_get_len") result(n)
      import :: c_ptr, c_size_t
      type(c_ptr), value :: val
      integer(c_size_t) :: n
    end function c_yyjson_get_len

    function c_yyjson_arr_size(arr) bind(c, name="fy_yyjson_arr_size") result(n)
      import :: c_ptr, c_size_t
      type(c_ptr), value :: arr
      integer(c_size_t) :: n
    end function c_yyjson_arr_size

    function c_yyjson_arr_get(arr, idx) bind(c, name="fy_yyjson_arr_get") result(val)
      import :: c_ptr, c_size_t
      type(c_ptr), value :: arr
      integer(c_size_t), value :: idx
      type(c_ptr) :: val
    end function c_yyjson_arr_get

    function c_yyjson_arr_get_first(arr) bind(c, name="fy_yyjson_arr_get_first") result(val)
      import :: c_ptr
      type(c_ptr), value :: arr
      type(c_ptr) :: val
    end function c_yyjson_arr_get_first

    function c_yyjson_arr_get_last(arr) bind(c, name="fy_yyjson_arr_get_last") result(val)
      import :: c_ptr
      type(c_ptr), value :: arr
      type(c_ptr) :: val
    end function c_yyjson_arr_get_last

    function c_yyjson_arr_iter_with(arr, iter) bind(c, name="fy_yyjson_arr_iter_with") result(ok)
      import :: c_ptr, c_bool
      type(c_ptr), value :: arr
      type(c_ptr), value :: iter
      logical(c_bool) :: ok
    end function c_yyjson_arr_iter_with

    function c_yyjson_arr_iter_next(iter) bind(c, name="fy_yyjson_arr_iter_next") result(val)
      import :: c_ptr
      type(c_ptr), value :: iter
      type(c_ptr) :: val
    end function c_yyjson_arr_iter_next

    function c_yyjson_obj_size(obj) bind(c, name="fy_yyjson_obj_size") result(n)
      import :: c_ptr, c_size_t
      type(c_ptr), value :: obj
      integer(c_size_t) :: n
    end function c_yyjson_obj_size

    function c_yyjson_obj_get(obj, key) bind(c, name="fy_yyjson_obj_get") result(val)
      import :: c_ptr, c_char
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      type(c_ptr) :: val
    end function c_yyjson_obj_get

    function c_yyjson_obj_getn(obj, key, key_len) bind(c, name="fy_yyjson_obj_getn") result(val)
      import :: c_ptr, c_char, c_size_t
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      integer(c_size_t), value :: key_len
      type(c_ptr) :: val
    end function c_yyjson_obj_getn

    function c_yyjson_obj_iter_with(obj, iter) bind(c, name="fy_yyjson_obj_iter_with") result(ok)
      import :: c_ptr, c_bool
      type(c_ptr), value :: obj
      type(c_ptr), value :: iter
      logical(c_bool) :: ok
    end function c_yyjson_obj_iter_with

    function c_yyjson_obj_iter_next(iter) bind(c, name="fy_yyjson_obj_iter_next") result(key)
      import :: c_ptr
      type(c_ptr), value :: iter
      type(c_ptr) :: key
    end function c_yyjson_obj_iter_next

    function c_yyjson_obj_iter_get_val(key) bind(c, name="fy_yyjson_obj_iter_get_val") result(val)
      import :: c_ptr
      type(c_ptr), value :: key
      type(c_ptr) :: val
    end function c_yyjson_obj_iter_get_val

    function c_yyjson_mut_doc_new(alc) bind(c, name="fy_yyjson_mut_doc_new") result(doc)
      import :: c_ptr
      type(c_ptr), value :: alc
      type(c_ptr) :: doc
    end function c_yyjson_mut_doc_new

    subroutine c_yyjson_mut_doc_free(doc) bind(c, name="fy_yyjson_mut_doc_free")
      import :: c_ptr
      type(c_ptr), value :: doc
    end subroutine c_yyjson_mut_doc_free

    subroutine c_yyjson_mut_doc_set_root(doc, val) bind(c, name="fy_yyjson_mut_doc_set_root")
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr), value :: val
    end subroutine c_yyjson_mut_doc_set_root

    function c_yyjson_mut_doc_get_root(doc) bind(c, name="fy_yyjson_mut_doc_get_root") result(val)
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr) :: val
    end function c_yyjson_mut_doc_get_root

    function c_yyjson_mut_write(doc, flg, len) bind(c, name="fy_yyjson_mut_write") result(str)
      import :: c_ptr, c_int
      type(c_ptr), value :: doc
      integer(c_int), value :: flg
      type(c_ptr), value :: len
      type(c_ptr) :: str
    end function c_yyjson_mut_write

    function c_yyjson_mut_write_opts(doc, flg, alc, len, err) bind(c, name="fy_yyjson_mut_write_opts") result(str)
      import :: c_ptr, c_int
      type(c_ptr), value :: doc
      integer(c_int), value :: flg
      type(c_ptr), value :: alc
      type(c_ptr), value :: len
      type(c_ptr), value :: err
      type(c_ptr) :: str
    end function c_yyjson_mut_write_opts

    function c_yyjson_mut_null(doc) bind(c, name="fy_yyjson_mut_null") result(val)
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr) :: val
    end function c_yyjson_mut_null

    function c_yyjson_mut_true(doc) bind(c, name="fy_yyjson_mut_true") result(val)
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr) :: val
    end function c_yyjson_mut_true

    function c_yyjson_mut_false(doc) bind(c, name="fy_yyjson_mut_false") result(val)
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr) :: val
    end function c_yyjson_mut_false

    function c_yyjson_mut_bool(doc, v) bind(c, name="fy_yyjson_mut_bool") result(val)
      import :: c_ptr, c_bool
      type(c_ptr), value :: doc
      logical(c_bool), value :: v
      type(c_ptr) :: val
    end function c_yyjson_mut_bool

    function c_yyjson_mut_sint(doc, v) bind(c, name="fy_yyjson_mut_sint") result(val)
      import :: c_ptr, c_int64_t
      type(c_ptr), value :: doc
      integer(c_int64_t), value :: v
      type(c_ptr) :: val
    end function c_yyjson_mut_sint

    function c_yyjson_mut_uint(doc, v) bind(c, name="fy_yyjson_mut_uint") result(val)
      import :: c_ptr, c_int64_t
      type(c_ptr), value :: doc
      integer(c_int64_t), value :: v
      type(c_ptr) :: val
    end function c_yyjson_mut_uint

    function c_yyjson_mut_real(doc, v) bind(c, name="fy_yyjson_mut_real") result(val)
      import :: c_ptr, c_double
      type(c_ptr), value :: doc
      real(c_double), value :: v
      type(c_ptr) :: val
    end function c_yyjson_mut_real

    function c_yyjson_mut_str(doc, str) bind(c, name="fy_yyjson_mut_str") result(val)
      import :: c_ptr, c_char
      type(c_ptr), value :: doc
      character(kind=c_char), dimension(*), intent(in) :: str
      type(c_ptr) :: val
    end function c_yyjson_mut_str

    function c_yyjson_mut_strn(doc, str, len) bind(c, name="fy_yyjson_mut_strn") result(val)
      import :: c_ptr, c_char, c_size_t
      type(c_ptr), value :: doc
      character(kind=c_char), dimension(*), intent(in) :: str
      integer(c_size_t), value :: len
      type(c_ptr) :: val
    end function c_yyjson_mut_strn

    function c_yyjson_mut_strcpy(doc, str) bind(c, name="fy_yyjson_mut_strcpy") result(val)
      import :: c_ptr, c_char
      type(c_ptr), value :: doc
      character(kind=c_char), dimension(*), intent(in) :: str
      type(c_ptr) :: val
    end function c_yyjson_mut_strcpy

    function c_yyjson_mut_strncpy(doc, str, len) bind(c, name="fy_yyjson_mut_strncpy") result(val)
      import :: c_ptr, c_char, c_size_t
      type(c_ptr), value :: doc
      character(kind=c_char), dimension(*), intent(in) :: str
      integer(c_size_t), value :: len
      type(c_ptr) :: val
    end function c_yyjson_mut_strncpy

    function c_yyjson_mut_arr(doc) bind(c, name="fy_yyjson_mut_arr") result(val)
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr) :: val
    end function c_yyjson_mut_arr

    function c_yyjson_mut_arr_add_val(arr, val) bind(c, name="fy_yyjson_mut_arr_add_val") result(ok)
      import :: c_ptr, c_bool
      type(c_ptr), value :: arr
      type(c_ptr), value :: val
      logical(c_bool) :: ok
    end function c_yyjson_mut_arr_add_val

    function c_yyjson_mut_arr_add_null(doc, arr) bind(c, name="fy_yyjson_mut_arr_add_null") result(ok)
      import :: c_ptr, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: arr
      logical(c_bool) :: ok
    end function c_yyjson_mut_arr_add_null

    function c_yyjson_mut_arr_add_bool(doc, arr, v) bind(c, name="fy_yyjson_mut_arr_add_bool") result(ok)
      import :: c_ptr, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: arr
      logical(c_bool), value :: v
      logical(c_bool) :: ok
    end function c_yyjson_mut_arr_add_bool

    function c_yyjson_mut_arr_add_sint(doc, arr, v) bind(c, name="fy_yyjson_mut_arr_add_sint") result(ok)
      import :: c_ptr, c_int64_t, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: arr
      integer(c_int64_t), value :: v
      logical(c_bool) :: ok
    end function c_yyjson_mut_arr_add_sint

    function c_yyjson_mut_arr_add_uint(doc, arr, v) bind(c, name="fy_yyjson_mut_arr_add_uint") result(ok)
      import :: c_ptr, c_int64_t, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: arr
      integer(c_int64_t), value :: v
      logical(c_bool) :: ok
    end function c_yyjson_mut_arr_add_uint

    function c_yyjson_mut_arr_add_real(doc, arr, v) bind(c, name="fy_yyjson_mut_arr_add_real") result(ok)
      import :: c_ptr, c_double, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: arr
      real(c_double), value :: v
      logical(c_bool) :: ok
    end function c_yyjson_mut_arr_add_real

    function c_yyjson_mut_arr_add_str(doc, arr, str) bind(c, name="fy_yyjson_mut_arr_add_str") result(ok)
      import :: c_ptr, c_char, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: arr
      character(kind=c_char), dimension(*), intent(in) :: str
      logical(c_bool) :: ok
    end function c_yyjson_mut_arr_add_str

    function c_yyjson_mut_arr_add_strn(doc, arr, str, len) bind(c, name="fy_yyjson_mut_arr_add_strn") result(ok)
      import :: c_ptr, c_char, c_size_t, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: arr
      character(kind=c_char), dimension(*), intent(in) :: str
      integer(c_size_t), value :: len
      logical(c_bool) :: ok
    end function c_yyjson_mut_arr_add_strn

    function c_yyjson_mut_obj(doc) bind(c, name="fy_yyjson_mut_obj") result(val)
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr) :: val
    end function c_yyjson_mut_obj

    function c_yyjson_mut_obj_add_val(doc, obj, key, val) bind(c, name="fy_yyjson_mut_obj_add_val") result(ok)
      import :: c_ptr, c_char, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      type(c_ptr), value :: val
      logical(c_bool) :: ok
    end function c_yyjson_mut_obj_add_val

    function c_yyjson_mut_obj_add_null(doc, obj, key) bind(c, name="fy_yyjson_mut_obj_add_null") result(ok)
      import :: c_ptr, c_char, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      logical(c_bool) :: ok
    end function c_yyjson_mut_obj_add_null

    function c_yyjson_mut_obj_add_bool(doc, obj, key, v) bind(c, name="fy_yyjson_mut_obj_add_bool") result(ok)
      import :: c_ptr, c_char, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      logical(c_bool), value :: v
      logical(c_bool) :: ok
    end function c_yyjson_mut_obj_add_bool

    function c_yyjson_mut_obj_add_sint(doc, obj, key, v) bind(c, name="fy_yyjson_mut_obj_add_sint") result(ok)
      import :: c_ptr, c_char, c_bool, c_int64_t
      type(c_ptr), value :: doc
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      integer(c_int64_t), value :: v
      logical(c_bool) :: ok
    end function c_yyjson_mut_obj_add_sint

    function c_yyjson_mut_obj_add_uint(doc, obj, key, v) bind(c, name="fy_yyjson_mut_obj_add_uint") result(ok)
      import :: c_ptr, c_char, c_bool, c_int64_t
      type(c_ptr), value :: doc
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      integer(c_int64_t), value :: v
      logical(c_bool) :: ok
    end function c_yyjson_mut_obj_add_uint

    function c_yyjson_mut_obj_add_real(doc, obj, key, v) bind(c, name="fy_yyjson_mut_obj_add_real") result(ok)
      import :: c_ptr, c_char, c_bool, c_double
      type(c_ptr), value :: doc
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      real(c_double), value :: v
      logical(c_bool) :: ok
    end function c_yyjson_mut_obj_add_real

    function c_yyjson_mut_obj_add_str(doc, obj, key, str) bind(c, name="fy_yyjson_mut_obj_add_str") result(ok)
      import :: c_ptr, c_char, c_bool
      type(c_ptr), value :: doc
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      character(kind=c_char), dimension(*), intent(in) :: str
      logical(c_bool) :: ok
    end function c_yyjson_mut_obj_add_str

    function c_yyjson_mut_obj_add_strn(doc, obj, key, str, len) bind(c, name="fy_yyjson_mut_obj_add_strn") result(ok)
      import :: c_ptr, c_char, c_bool, c_size_t
      type(c_ptr), value :: doc
      type(c_ptr), value :: obj
      character(kind=c_char), dimension(*), intent(in) :: key
      character(kind=c_char), dimension(*), intent(in) :: str
      integer(c_size_t), value :: len
      logical(c_bool) :: ok
    end function c_yyjson_mut_obj_add_strn

    function c_yyjson_mut_val_mut_copy(doc, val) bind(c, name="fy_yyjson_mut_val_mut_copy") result(cp)
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr), value :: val
      type(c_ptr) :: cp
    end function c_yyjson_mut_val_mut_copy

    function c_yyjson_val_mut_copy(doc, val) bind(c, name="fy_yyjson_val_mut_copy") result(cp)
      import :: c_ptr
      type(c_ptr), value :: doc
      type(c_ptr), value :: val
      type(c_ptr) :: cp
    end function c_yyjson_val_mut_copy

  end interface

end module yyjson_capi
