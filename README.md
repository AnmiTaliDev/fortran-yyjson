# fortran-yyjson

Modern Fortran bindings for [yyjson](https://github.com/ibireme/yyjson), a
fast, portable, ANSI C JSON library. 

## Requirements

- A Fortran compiler supporting the Fortran 2008 standard or later
  (gfortran, ifx, nvfortran, flang, ...).
- A C compiler (yyjson itself, and the glue layer, are plain C).
- [fpm](https://fpm.fortran-lang.org) or [CMake](https://cmake.org) (>= 3.16)
  to build and test the package.

This package is not published to the official fpm registry (it has been
unmaintained for a while) — depend on it directly via git instead.

## Installation

### fpm

Add this package as a git dependency in your `fpm.toml`:

```toml
[dependencies]
fortran-yyjson = { git = "https://github.com/AnmiTaliDev/fortran-yyjson.git" }
```

### CMake

Alternatively, clone the repository and build/install it with CMake:

```sh
git clone https://github.com/AnmiTaliDev/fortran-yyjson.git
cmake -S fortran-yyjson -B build -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build build
cmake --install build
```

This installs the static library, the compiled `.mod` files, and a
`fortran-yyjson.pc` pkg-config file, so downstream projects can pick up the
compiler and linker flags with:

```sh
gfortran my_program.f90 -o my_program $(pkg-config --cflags --libs fortran-yyjson)
```

You can also add it as a subdirectory or via `FetchContent`/`find_package`
in another CMake project and link against the `fortran-yyjson::fortran-yyjson`
target.

## Building

With fpm:

```sh
fpm build
fpm test
fpm run --example read_json
fpm run --example write_json
fpm run --example mutate_json
```

With CMake:

```sh
cmake -S . -B build
cmake --build build
ctest --test-dir build
```

Examples and tests are built by default when CMake is configured directly on
this repository. Pass `-DBUILD_TESTING=OFF` and/or `-DBUILD_EXAMPLES=OFF` to
skip them (they are already off by default when this project is pulled in as
a CMake subdirectory of another project).

## Usage

### Reading JSON

```fortran
use yyjson_module

type(json_document) :: doc
type(json_value) :: root, name_val

doc = json_parse('{"name":"Mash","star":4,"hits":[2,2,1,3]}')
if (.not. doc%is_valid()) stop "invalid JSON"

root = doc%root()
name_val = root%object_get("name")
print *, name_val%to_chars()

call doc%destroy()
```

### Iterating arrays and objects

```fortran
type(json_array_iterator) :: it
type(json_value) :: item

it = root%object_get("hits")%array_iterator()
do while (it%has_next())
  item = it%next()
  print *, item%to_integer()
end do
```

### Writing JSON

```fortran
use yyjson_module

type(json_mut_document) :: doc
type(json_mut_value) :: root
character(len=:), allocatable :: text

call doc%init()
root = doc%new_object()
call doc%object_add_string(root, "name", "Mash")
call doc%object_add_integer(root, "star", 4_c_int64_t)
call doc%set_root(root)

text = doc%to_chars(pretty=.true.)
print *, text

call doc%destroy()
```

See `example/read_json.f90`, `example/write_json.f90`, and
`example/mutate_json.f90` for complete, runnable programs.

## API overview

| Type                 | Purpose                                          |
|-----------------------|--------------------------------------------------|
| `json_document`       | Owns a parsed, immutable JSON value tree.        |
| `json_value`           | A handle to a single immutable JSON value.       |
| `json_mut_document`    | Owns a document being built or edited.           |
| `json_mut_value`       | A handle to a single mutable JSON value.         |
| `json_array_iterator`  | Forward iterator over an immutable JSON array.   |
| `json_object_iterator` | Forward iterator over an immutable JSON object.  |

Documents own the memory of every value inside them; values themselves are
lightweight, non-owning handles that stay valid as long as their document is
not destroyed.

## License

This project is released under the MIT License. It bundles yyjson, which is
also MIT licensed. See [LICENSE](LICENSE) for full text and copyright
notices.

## Author

AnmiTaliDev <anmitalidev@nuros.org>
