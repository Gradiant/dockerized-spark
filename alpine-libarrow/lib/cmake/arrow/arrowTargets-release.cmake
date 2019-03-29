#----------------------------------------------------------------
# Generated CMake target import file for configuration "RELEASE".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "arrow_shared" for configuration "RELEASE"
set_property(TARGET arrow_shared APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(arrow_shared PROPERTIES
  IMPORTED_LINK_DEPENDENT_LIBRARIES_RELEASE "zlib_shared;boost_system_shared;boost_filesystem_shared;boost_regex_shared"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libarrow.so.12.1.0"
  IMPORTED_SONAME_RELEASE "libarrow.so.12"
  )

list(APPEND _IMPORT_CHECK_TARGETS arrow_shared )
list(APPEND _IMPORT_CHECK_FILES_FOR_arrow_shared "${_IMPORT_PREFIX}/lib/libarrow.so.12.1.0" )

# Import target "arrow_static" for configuration "RELEASE"
set_property(TARGET arrow_static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(arrow_static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libarrow.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS arrow_static )
list(APPEND _IMPORT_CHECK_FILES_FOR_arrow_static "${_IMPORT_PREFIX}/lib/libarrow.a" )

# Import target "arrow_python_shared" for configuration "RELEASE"
set_property(TARGET arrow_python_shared APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(arrow_python_shared PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libarrow_python.so.12.1.0"
  IMPORTED_SONAME_RELEASE "libarrow_python.so.12"
  )

list(APPEND _IMPORT_CHECK_TARGETS arrow_python_shared )
list(APPEND _IMPORT_CHECK_FILES_FOR_arrow_python_shared "${_IMPORT_PREFIX}/lib/libarrow_python.so.12.1.0" )

# Import target "arrow_python_static" for configuration "RELEASE"
set_property(TARGET arrow_python_static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(arrow_python_static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libarrow_python.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS arrow_python_static )
list(APPEND _IMPORT_CHECK_FILES_FOR_arrow_python_static "${_IMPORT_PREFIX}/lib/libarrow_python.a" )

# Import target "parquet_shared" for configuration "RELEASE"
set_property(TARGET parquet_shared APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(parquet_shared PROPERTIES
  IMPORTED_LINK_DEPENDENT_LIBRARIES_RELEASE "boost_regex_shared"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libparquet.so.12.1.0"
  IMPORTED_SONAME_RELEASE "libparquet.so.12"
  )

list(APPEND _IMPORT_CHECK_TARGETS parquet_shared )
list(APPEND _IMPORT_CHECK_FILES_FOR_parquet_shared "${_IMPORT_PREFIX}/lib/libparquet.so.12.1.0" )

# Import target "parquet_static" for configuration "RELEASE"
set_property(TARGET parquet_static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(parquet_static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libparquet.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS parquet_static )
list(APPEND _IMPORT_CHECK_FILES_FOR_parquet_static "${_IMPORT_PREFIX}/lib/libparquet.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
