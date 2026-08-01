! SPDX-License-Identifier: MIT
!> @file yyjson_module.f90
!> @brief High-level Fortran bindings for the yyjson C library.
!> @author AnmiTaliDev <anmitalidev@nuros.org>
module yyjson_module
  use, intrinsic :: iso_c_binding
  use yyjson_capi
  use yyjson_constants
  implicit none
  private

  public :: json_document
  public :: json_value
  public :: json_mut_document
  public :: json_mut_value
  public :: json_array_iterator
  public :: json_object_iterator

  public :: json_type_none
  public :: json_type_null
  public :: json_type_bool
  public :: json_type_number
  public :: json_type_string
  public :: json_type_array
  public :: json_type_object
  public :: json_type_raw

  public :: YYJSON_READ_NOFLAG
  public :: YYJSON_READ_ALLOW_TRAILING_COMMAS
  public :: YYJSON_READ_ALLOW_COMMENTS
  public :: YYJSON_READ_ALLOW_INF_AND_NAN
  public :: YYJSON_WRITE_NOFLAG
  public :: YYJSON_WRITE_PRETTY
  public :: YYJSON_WRITE_ESCAPE_UNICODE

  integer, parameter :: json_type_none   = 0
  integer, parameter :: json_type_raw    = 1
  integer, parameter :: json_type_null   = 2
  integer, parameter :: json_type_bool   = 3
  integer, parameter :: json_type_number = 4
  integer, parameter :: json_type_string = 5
  integer, parameter :: json_type_array  = 6
  integer, parameter :: json_type_object = 7

  !> @brief Immutable JSON value handle.
  type :: json_value
    type(c_ptr) :: ptr = c_null_ptr
  contains
    procedure :: is_valid       => value_is_valid
    procedure :: json_type      => value_type
    procedure :: is_null        => value_is_null
    procedure :: is_bool        => value_is_bool
    procedure :: is_true        => value_is_true
    procedure :: is_false       => value_is_false
    procedure :: is_number      => value_is_number
    procedure :: is_integer     => value_is_integer
    procedure :: is_real        => value_is_real
    procedure :: is_string      => value_is_string
    procedure :: is_array       => value_is_array
    procedure :: is_object      => value_is_object
    procedure :: to_logical     => value_to_logical
    procedure :: to_integer     => value_to_integer
    procedure :: to_real        => value_to_real
    procedure :: to_chars       => value_to_chars
    procedure :: array_size     => value_array_size
    procedure :: array_get      => value_array_get
    procedure :: object_size    => value_object_size
    procedure :: object_get     => value_object_get
    procedure :: array_iterator => value_array_iterator
    procedure :: object_iterator => value_object_iterator
  end type json_value

  !> @brief Immutable JSON document owning the parsed value tree.
  type :: json_document
    type(c_ptr), private :: doc_ptr = c_null_ptr
  contains
    procedure :: is_valid => doc_is_valid
    procedure :: root     => doc_root
    procedure :: to_chars => doc_to_chars
    procedure :: destroy  => doc_destroy
  end type json_document

  !> @brief Mutable JSON value handle, used to build documents.
  type :: json_mut_value
    type(c_ptr) :: ptr = c_null_ptr
  contains
    procedure :: is_valid => mvalue_is_valid
  end type json_mut_value

  !> @brief Mutable JSON document used to construct JSON trees.
  type :: json_mut_document
    type(c_ptr), private :: doc_ptr = c_null_ptr
  contains
    procedure :: init            => mdoc_init
    procedure :: is_valid        => mdoc_is_valid
    procedure :: set_root        => mdoc_set_root
    procedure :: root            => mdoc_root
    procedure :: new_null        => mdoc_new_null
    procedure :: new_true        => mdoc_new_true
    procedure :: new_false       => mdoc_new_false
    procedure :: new_bool        => mdoc_new_bool
    procedure :: new_integer     => mdoc_new_integer
    procedure :: new_real        => mdoc_new_real
    procedure :: new_string      => mdoc_new_string
    procedure :: new_array       => mdoc_new_array
    procedure :: new_object      => mdoc_new_object
    procedure :: array_add       => mdoc_array_add
    procedure :: array_add_integer => mdoc_array_add_integer
    procedure :: array_add_real  => mdoc_array_add_real
    procedure :: array_add_string => mdoc_array_add_string
    procedure :: array_add_bool  => mdoc_array_add_bool
    procedure :: object_add      => mdoc_object_add
    procedure :: object_add_integer => mdoc_object_add_integer
    procedure :: object_add_real => mdoc_object_add_real
    procedure :: object_add_string => mdoc_object_add_string
    procedure :: object_add_bool => mdoc_object_add_bool
    procedure :: to_chars         => mdoc_to_chars
    procedure :: destroy          => mdoc_destroy
  end type json_mut_document

  !> @brief Forward iterator over an immutable JSON array.
  type :: json_array_iterator
    type(yyjson_arr_iter_c), private :: it
    logical, private :: ok = .false.
  contains
    procedure :: has_next => arr_iter_has_next
    procedure :: next     => arr_iter_next
  end type json_array_iterator

  !> @brief Forward iterator over an immutable JSON object.
  type :: json_object_iterator
    type(yyjson_obj_iter_c), private :: it
    logical, private :: ok = .false.
  contains
    procedure :: has_next => obj_iter_has_next
    procedure :: next     => obj_iter_next
  end type json_object_iterator

  public :: json_parse
  public :: json_parse_file

contains

  !> @brief Parse a JSON document from a character string.
  function json_parse(text, flags) result(doc)
    character(len=*), intent(in) :: text
    integer, intent(in), optional :: flags
    type(json_document) :: doc
    integer(c_int) :: use_flags

    use_flags = YYJSON_READ_NOFLAG
    if (present(flags)) use_flags = int(flags, c_int)

    doc%doc_ptr = c_yyjson_read(to_c_string(text), &
                                 int(len(text), c_size_t), use_flags)
  end function json_parse

  !> @brief Parse a JSON document from a file on disk.
  function json_parse_file(path, flags) result(doc)
    character(len=*), intent(in) :: path
    integer, intent(in), optional :: flags
    type(json_document) :: doc
    integer :: unit, ios, file_size
    character(len=:), allocatable :: buffer

    inquire (file=path, size=file_size)
    if (file_size <= 0) return

    allocate (character(len=file_size) :: buffer)
    open (newunit=unit, file=path, access="stream", form="unformatted", &
          status="old", action="read", iostat=ios)
    if (ios /= 0) return
    read (unit, iostat=ios) buffer
    close (unit)
    if (ios /= 0) return

    doc = json_parse(buffer, flags)
    deallocate (buffer)
  end function json_parse_file

  function doc_is_valid(self) result(valid)
    class(json_document), intent(in) :: self
    logical :: valid
    valid = c_associated(self%doc_ptr)
  end function doc_is_valid

  function doc_root(self) result(val)
    class(json_document), intent(in) :: self
    type(json_value) :: val
    if (c_associated(self%doc_ptr)) then
      val%ptr = c_yyjson_doc_get_root(self%doc_ptr)
    else
      val%ptr = c_null_ptr
    end if
  end function doc_root

  function doc_to_chars(self, pretty) result(text)
    class(json_document), intent(in) :: self
    logical, intent(in), optional :: pretty
    character(len=:), allocatable :: text
    type(c_ptr) :: cstr
    integer(c_size_t), target :: out_len
    integer(c_int) :: flags

    flags = YYJSON_WRITE_NOFLAG
    if (present(pretty)) then
      if (pretty) flags = YYJSON_WRITE_PRETTY
    end if

    if (.not. c_associated(self%doc_ptr)) then
      text = ""
      return
    end if

    cstr = c_yyjson_write(self%doc_ptr, flags, c_loc(out_len))
    if (.not. c_associated(cstr)) then
      text = ""
      return
    end if

    text = c_string_to_fortran(cstr, out_len)
    call c_free(cstr)
  end function doc_to_chars

  subroutine doc_destroy(self)
    class(json_document), intent(inout) :: self
    if (c_associated(self%doc_ptr)) then
      call c_yyjson_doc_free(self%doc_ptr)
      self%doc_ptr = c_null_ptr
    end if
  end subroutine doc_destroy

  function value_is_valid(self) result(valid)
    class(json_value), intent(in) :: self
    logical :: valid
    valid = c_associated(self%ptr)
  end function value_is_valid

  function value_type(self) result(t)
    class(json_value), intent(in) :: self
    integer :: t
    t = int(c_yyjson_get_type(self%ptr))
  end function value_type

  function value_is_null(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_null(self%ptr))
  end function value_is_null

  function value_is_bool(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_bool(self%ptr))
  end function value_is_bool

  function value_is_true(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_true(self%ptr))
  end function value_is_true

  function value_is_false(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_false(self%ptr))
  end function value_is_false

  function value_is_number(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_num(self%ptr))
  end function value_is_number

  function value_is_integer(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_int(self%ptr))
  end function value_is_integer

  function value_is_real(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_real(self%ptr))
  end function value_is_real

  function value_is_string(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_str(self%ptr))
  end function value_is_string

  function value_is_array(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_arr(self%ptr))
  end function value_is_array

  function value_is_object(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_is_obj(self%ptr))
  end function value_is_object

  function value_to_logical(self) result(r)
    class(json_value), intent(in) :: self
    logical :: r
    r = logical(c_yyjson_get_bool(self%ptr))
  end function value_to_logical

  function value_to_integer(self) result(r)
    class(json_value), intent(in) :: self
    integer(c_int64_t) :: r
    r = c_yyjson_get_sint(self%ptr)
  end function value_to_integer

  function value_to_real(self) result(r)
    class(json_value), intent(in) :: self
    real(c_double) :: r
    r = c_yyjson_get_num(self%ptr)
  end function value_to_real

  function value_to_chars(self) result(text)
    class(json_value), intent(in) :: self
    character(len=:), allocatable :: text
    type(c_ptr) :: cstr
    integer(c_size_t) :: n

    if (.not. c_associated(self%ptr)) then
      text = ""
      return
    end if

    cstr = c_yyjson_get_str(self%ptr)
    if (.not. c_associated(cstr)) then
      text = ""
      return
    end if

    n = c_yyjson_get_len(self%ptr)
    text = c_string_to_fortran(cstr, n)
  end function value_to_chars

  function value_array_size(self) result(n)
    class(json_value), intent(in) :: self
    integer(c_size_t) :: n
    n = c_yyjson_arr_size(self%ptr)
  end function value_array_size

  function value_array_get(self, idx) result(val)
    class(json_value), intent(in) :: self
    integer, intent(in) :: idx
    type(json_value) :: val
    val%ptr = c_yyjson_arr_get(self%ptr, int(idx, c_size_t))
  end function value_array_get

  function value_object_size(self) result(n)
    class(json_value), intent(in) :: self
    integer(c_size_t) :: n
    n = c_yyjson_obj_size(self%ptr)
  end function value_object_size

  function value_object_get(self, key) result(val)
    class(json_value), intent(in) :: self
    character(len=*), intent(in) :: key
    type(json_value) :: val
    val%ptr = c_yyjson_obj_get(self%ptr, to_c_string(key))
  end function value_object_get

  function value_array_iterator(self) result(it)
    class(json_value), intent(in), target :: self
    type(json_array_iterator), target :: it
    it%ok = logical(c_yyjson_arr_iter_with(self%ptr, c_loc(it%it)))
  end function value_array_iterator

  function value_object_iterator(self) result(it)
    class(json_value), intent(in), target :: self
    type(json_object_iterator), target :: it
    it%ok = logical(c_yyjson_obj_iter_with(self%ptr, c_loc(it%it)))
  end function value_object_iterator

  function arr_iter_has_next(self) result(r)
    class(json_array_iterator), intent(in) :: self
    logical :: r
    r = self%ok .and. (self%it%idx < self%it%max)
  end function arr_iter_has_next

  function arr_iter_next(self) result(val)
    class(json_array_iterator), intent(inout), target :: self
    type(json_value) :: val
    val%ptr = c_yyjson_arr_iter_next(c_loc(self%it))
  end function arr_iter_next

  function obj_iter_has_next(self) result(r)
    class(json_object_iterator), intent(in) :: self
    logical :: r
    r = self%ok .and. (self%it%idx < self%it%max)
  end function obj_iter_has_next

  function obj_iter_next(self, key) result(val)
    class(json_object_iterator), intent(inout), target :: self
    character(len=:), allocatable, intent(out) :: key
    type(json_value) :: val
    type(c_ptr) :: key_ptr
    type(json_value) :: key_val

    key_ptr = c_yyjson_obj_iter_next(c_loc(self%it))
    key_val%ptr = key_ptr
    key = key_val%to_chars()
    val%ptr = c_yyjson_obj_iter_get_val(key_ptr)
  end function obj_iter_next

  function mvalue_is_valid(self) result(valid)
    class(json_mut_value), intent(in) :: self
    logical :: valid
    valid = c_associated(self%ptr)
  end function mvalue_is_valid

  subroutine mdoc_init(self)
    class(json_mut_document), intent(inout) :: self
    self%doc_ptr = c_yyjson_mut_doc_new(c_null_ptr)
  end subroutine mdoc_init

  function mdoc_is_valid(self) result(valid)
    class(json_mut_document), intent(in) :: self
    logical :: valid
    valid = c_associated(self%doc_ptr)
  end function mdoc_is_valid

  subroutine mdoc_set_root(self, val)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(in) :: val
    call c_yyjson_mut_doc_set_root(self%doc_ptr, val%ptr)
  end subroutine mdoc_set_root

  function mdoc_root(self) result(val)
    class(json_mut_document), intent(in) :: self
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_doc_get_root(self%doc_ptr)
  end function mdoc_root

  function mdoc_new_null(self) result(val)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_null(self%doc_ptr)
  end function mdoc_new_null

  function mdoc_new_true(self) result(val)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_true(self%doc_ptr)
  end function mdoc_new_true

  function mdoc_new_false(self) result(val)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_false(self%doc_ptr)
  end function mdoc_new_false

  function mdoc_new_bool(self, v) result(val)
    class(json_mut_document), intent(inout) :: self
    logical, intent(in) :: v
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_bool(self%doc_ptr, logical(v, c_bool))
  end function mdoc_new_bool

  function mdoc_new_integer(self, v) result(val)
    class(json_mut_document), intent(inout) :: self
    integer(c_int64_t), intent(in) :: v
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_sint(self%doc_ptr, v)
  end function mdoc_new_integer

  function mdoc_new_real(self, v) result(val)
    class(json_mut_document), intent(inout) :: self
    real(c_double), intent(in) :: v
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_real(self%doc_ptr, v)
  end function mdoc_new_real

  function mdoc_new_string(self, v) result(val)
    class(json_mut_document), intent(inout) :: self
    character(len=*), intent(in) :: v
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_strncpy(self%doc_ptr, to_c_string(v), int(len(v), c_size_t))
  end function mdoc_new_string

  function mdoc_new_array(self) result(val)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_arr(self%doc_ptr)
  end function mdoc_new_array

  function mdoc_new_object(self) result(val)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value) :: val
    val%ptr = c_yyjson_mut_obj(self%doc_ptr)
  end function mdoc_new_object

  subroutine mdoc_array_add(self, arr, val)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: arr
    type(json_mut_value), intent(in) :: val
    logical(c_bool) :: ok
    ok = c_yyjson_mut_arr_add_val(arr%ptr, val%ptr)
  end subroutine mdoc_array_add

  subroutine mdoc_array_add_integer(self, arr, v)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: arr
    integer(c_int64_t), intent(in) :: v
    logical(c_bool) :: ok
    ok = c_yyjson_mut_arr_add_sint(self%doc_ptr, arr%ptr, v)
  end subroutine mdoc_array_add_integer

  subroutine mdoc_array_add_real(self, arr, v)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: arr
    real(c_double), intent(in) :: v
    logical(c_bool) :: ok
    ok = c_yyjson_mut_arr_add_real(self%doc_ptr, arr%ptr, v)
  end subroutine mdoc_array_add_real

  subroutine mdoc_array_add_string(self, arr, v)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: arr
    character(len=*), intent(in) :: v
    logical(c_bool) :: ok
    ok = c_yyjson_mut_arr_add_strn(self%doc_ptr, arr%ptr, to_c_string(v), int(len(v), c_size_t))
  end subroutine mdoc_array_add_string

  subroutine mdoc_array_add_bool(self, arr, v)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: arr
    logical, intent(in) :: v
    logical(c_bool) :: ok
    ok = c_yyjson_mut_arr_add_bool(self%doc_ptr, arr%ptr, logical(v, c_bool))
  end subroutine mdoc_array_add_bool

  subroutine mdoc_object_add(self, obj, key, val)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: obj
    character(len=*), intent(in) :: key
    type(json_mut_value), intent(in) :: val
    logical(c_bool) :: ok
    ok = c_yyjson_mut_obj_add_val(self%doc_ptr, obj%ptr, to_c_string(key), val%ptr)
  end subroutine mdoc_object_add

  subroutine mdoc_object_add_integer(self, obj, key, v)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: obj
    character(len=*), intent(in) :: key
    integer(c_int64_t), intent(in) :: v
    logical(c_bool) :: ok
    ok = c_yyjson_mut_obj_add_sint(self%doc_ptr, obj%ptr, to_c_string(key), v)
  end subroutine mdoc_object_add_integer

  subroutine mdoc_object_add_real(self, obj, key, v)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: obj
    character(len=*), intent(in) :: key
    real(c_double), intent(in) :: v
    logical(c_bool) :: ok
    ok = c_yyjson_mut_obj_add_real(self%doc_ptr, obj%ptr, to_c_string(key), v)
  end subroutine mdoc_object_add_real

  subroutine mdoc_object_add_string(self, obj, key, v)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: obj
    character(len=*), intent(in) :: key
    character(len=*), intent(in) :: v
    logical(c_bool) :: ok
    ok = c_yyjson_mut_obj_add_strn(self%doc_ptr, obj%ptr, to_c_string(key), &
                                    to_c_string(v), int(len(v), c_size_t))
  end subroutine mdoc_object_add_string

  subroutine mdoc_object_add_bool(self, obj, key, v)
    class(json_mut_document), intent(inout) :: self
    type(json_mut_value), intent(inout) :: obj
    character(len=*), intent(in) :: key
    logical, intent(in) :: v
    logical(c_bool) :: ok
    ok = c_yyjson_mut_obj_add_bool(self%doc_ptr, obj%ptr, to_c_string(key), logical(v, c_bool))
  end subroutine mdoc_object_add_bool

  function mdoc_to_chars(self, pretty) result(text)
    class(json_mut_document), intent(in) :: self
    logical, intent(in), optional :: pretty
    character(len=:), allocatable :: text
    type(c_ptr) :: cstr
    integer(c_size_t), target :: out_len
    integer(c_int) :: flags

    flags = YYJSON_WRITE_NOFLAG
    if (present(pretty)) then
      if (pretty) flags = YYJSON_WRITE_PRETTY
    end if

    if (.not. c_associated(self%doc_ptr)) then
      text = ""
      return
    end if

    cstr = c_yyjson_mut_write(self%doc_ptr, flags, c_loc(out_len))
    if (.not. c_associated(cstr)) then
      text = ""
      return
    end if

    text = c_string_to_fortran(cstr, out_len)
    call c_free(cstr)
  end function mdoc_to_chars

  subroutine mdoc_destroy(self)
    class(json_mut_document), intent(inout) :: self
    if (c_associated(self%doc_ptr)) then
      call c_yyjson_mut_doc_free(self%doc_ptr)
      self%doc_ptr = c_null_ptr
    end if
  end subroutine mdoc_destroy

  function to_c_string(text) result(cstr)
    character(len=*), intent(in) :: text
    character(kind=c_char, len=len(text) + 1) :: cstr
    cstr = text // c_null_char
  end function to_c_string

  function c_string_to_fortran(cstr, length) result(text)
    type(c_ptr), intent(in) :: cstr
    integer(c_size_t), intent(in) :: length
    character(len=:), allocatable :: text
    character(kind=c_char), pointer :: chars(:)
    integer :: i, n

    n = int(length)
    if (n <= 0 .or. .not. c_associated(cstr)) then
      text = ""
      return
    end if

    call c_f_pointer(cstr, chars, [n])
    allocate (character(len=n) :: text)
    do i = 1, n
      text(i:i) = chars(i)
    end do
  end function c_string_to_fortran

end module yyjson_module
