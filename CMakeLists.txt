cmake_minimum_required(VERSION 3.16)

project(fortran-yyjson
  VERSION 0.1.0
  DESCRIPTION "Fortran bindings for yyjson, a fast C JSON library"
  HOMEPAGE_URL "https://github.com/AnmiTaliDev/fortran-yyjson"
  LANGUAGES C Fortran)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  set(FORTRAN_YYJSON_IS_TOP_LEVEL ON)
else()
  set(FORTRAN_YYJSON_IS_TOP_LEVEL OFF)
endif()

option(BUILD_TESTING "Build the test suite" ${FORTRAN_YYJSON_IS_TOP_LEVEL})
option(BUILD_EXAMPLES "Build the example programs" ${FORTRAN_YYJSON_IS_TOP_LEVEL})

include(GNUInstallDirs)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/modules)

add_library(fortran-yyjson
  src/yyjson.c
  src/yyjson_glue.c
  src/yyjson_constants.f90
  src/yyjson_capi.f90
  src/yyjson_module.f90
)
add_library(fortran-yyjson::fortran-yyjson ALIAS fortran-yyjson)

target_include_directories(fortran-yyjson
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/fortran-yyjson>
)

if(BUILD_TESTING)
  enable_testing()
  add_executable(test_yyjson test/test_yyjson.f90)
  target_link_libraries(test_yyjson PRIVATE fortran-yyjson)
  add_test(NAME yyjson_tests COMMAND test_yyjson)
endif()

if(BUILD_EXAMPLES)
  foreach(example_name read_json write_json mutate_json)
    add_executable(${example_name} example/${example_name}.f90)
    target_link_libraries(${example_name} PRIVATE fortran-yyjson)
  endforeach()
endif()

set(PKG_CONFIG_LIBDIR "\${prefix}/${CMAKE_INSTALL_LIBDIR}")
set(PKG_CONFIG_INCLUDEDIR "\${prefix}/${CMAKE_INSTALL_INCLUDEDIR}/fortran-yyjson")
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/fortran-yyjson.pc.in
  ${CMAKE_CURRENT_BINARY_DIR}/fortran-yyjson.pc
  @ONLY
)

install(TARGETS fortran-yyjson
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY}/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/fortran-yyjson
  FILES_MATCHING PATTERN "*.mod"
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/fortran-yyjson.pc
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
)
