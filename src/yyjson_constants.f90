! SPDX-License-Identifier: MIT
module yyjson_constants
  use, intrinsic :: iso_c_binding, only: c_int
  implicit none
  private

  public :: YYJSON_READ_NOFLAG
  public :: YYJSON_READ_INSITU
  public :: YYJSON_READ_STOP_WHEN_DONE
  public :: YYJSON_READ_ALLOW_TRAILING_COMMAS
  public :: YYJSON_READ_ALLOW_COMMENTS
  public :: YYJSON_READ_ALLOW_INF_AND_NAN
  public :: YYJSON_READ_NUMBER_AS_RAW
  public :: YYJSON_READ_ALLOW_INVALID_UNICODE
  public :: YYJSON_READ_BIGNUM_AS_RAW

  public :: YYJSON_WRITE_NOFLAG
  public :: YYJSON_WRITE_PRETTY
  public :: YYJSON_WRITE_ESCAPE_UNICODE
  public :: YYJSON_WRITE_ESCAPE_SLASHES
  public :: YYJSON_WRITE_ALLOW_INF_AND_NAN
  public :: YYJSON_WRITE_INF_AND_NAN_AS_NULL
  public :: YYJSON_WRITE_ALLOW_INVALID_UNICODE
  public :: YYJSON_WRITE_PRETTY_TWO_SPACES
  public :: YYJSON_WRITE_NEWLINE_AT_END

  public :: YYJSON_TYPE_NONE
  public :: YYJSON_TYPE_RAW
  public :: YYJSON_TYPE_NULL
  public :: YYJSON_TYPE_BOOL
  public :: YYJSON_TYPE_NUM
  public :: YYJSON_TYPE_STR
  public :: YYJSON_TYPE_ARR
  public :: YYJSON_TYPE_OBJ

  public :: YYJSON_SUBTYPE_NONE
  public :: YYJSON_SUBTYPE_FALSE
  public :: YYJSON_SUBTYPE_TRUE
  public :: YYJSON_SUBTYPE_UINT
  public :: YYJSON_SUBTYPE_SINT
  public :: YYJSON_SUBTYPE_REAL

  integer(c_int), parameter :: YYJSON_READ_NOFLAG                  = 0
  integer(c_int), parameter :: YYJSON_READ_INSITU                  = int(z'01', c_int)
  integer(c_int), parameter :: YYJSON_READ_STOP_WHEN_DONE           = int(z'02', c_int)
  integer(c_int), parameter :: YYJSON_READ_ALLOW_TRAILING_COMMAS    = int(z'04', c_int)
  integer(c_int), parameter :: YYJSON_READ_ALLOW_COMMENTS           = int(z'08', c_int)
  integer(c_int), parameter :: YYJSON_READ_ALLOW_INF_AND_NAN        = int(z'10', c_int)
  integer(c_int), parameter :: YYJSON_READ_NUMBER_AS_RAW            = int(z'20', c_int)
  integer(c_int), parameter :: YYJSON_READ_ALLOW_INVALID_UNICODE    = int(z'40', c_int)
  integer(c_int), parameter :: YYJSON_READ_BIGNUM_AS_RAW            = int(z'80', c_int)

  integer(c_int), parameter :: YYJSON_WRITE_NOFLAG                  = 0
  integer(c_int), parameter :: YYJSON_WRITE_PRETTY                  = int(z'01', c_int)
  integer(c_int), parameter :: YYJSON_WRITE_ESCAPE_UNICODE          = int(z'02', c_int)
  integer(c_int), parameter :: YYJSON_WRITE_ESCAPE_SLASHES          = int(z'04', c_int)
  integer(c_int), parameter :: YYJSON_WRITE_ALLOW_INF_AND_NAN       = int(z'08', c_int)
  integer(c_int), parameter :: YYJSON_WRITE_INF_AND_NAN_AS_NULL     = int(z'10', c_int)
  integer(c_int), parameter :: YYJSON_WRITE_ALLOW_INVALID_UNICODE   = int(z'20', c_int)
  integer(c_int), parameter :: YYJSON_WRITE_PRETTY_TWO_SPACES       = int(z'40', c_int)
  integer(c_int), parameter :: YYJSON_WRITE_NEWLINE_AT_END          = int(z'80', c_int)

  integer(c_int), parameter :: YYJSON_TYPE_NONE = 0
  integer(c_int), parameter :: YYJSON_TYPE_RAW  = 1
  integer(c_int), parameter :: YYJSON_TYPE_NULL = 2
  integer(c_int), parameter :: YYJSON_TYPE_BOOL = 3
  integer(c_int), parameter :: YYJSON_TYPE_NUM  = 4
  integer(c_int), parameter :: YYJSON_TYPE_STR  = 5
  integer(c_int), parameter :: YYJSON_TYPE_ARR  = 6
  integer(c_int), parameter :: YYJSON_TYPE_OBJ  = 7

  integer(c_int), parameter :: YYJSON_SUBTYPE_NONE  = int(z'00', c_int)
  integer(c_int), parameter :: YYJSON_SUBTYPE_FALSE = int(z'00', c_int)
  integer(c_int), parameter :: YYJSON_SUBTYPE_TRUE  = int(z'08', c_int)
  integer(c_int), parameter :: YYJSON_SUBTYPE_UINT  = int(z'00', c_int)
  integer(c_int), parameter :: YYJSON_SUBTYPE_SINT  = int(z'08', c_int)
  integer(c_int), parameter :: YYJSON_SUBTYPE_REAL  = int(z'10', c_int)

end module yyjson_constants
