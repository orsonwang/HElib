# Use cmake standard find_library package
include(FindPackageHandleStandardArgs)

if (NTL_DIR)
  # If user-specified folders: look there
  find_library(NTL_LIB NAMES ntl libntl
               PATHS ${NTL_DIR}
               PATH_SUFFIXES lib
               NO_DEFAULT_PATH
               DOC "NTL library")

  find_path(NTL_HEADERS NAMES config.h
            PATHS ${NTL_DIR}
            PATH_SUFFIXES include/NTL
            NO_DEFAULT_PATH
            DOC "NTL headers")

else (NTL_DIR)
# Else: look in default paths
  find_library(NTL_LIB NAMES ntl libntl
               PATH_SUFFIXES lib
               DOC "NTL library")

  find_path(NTL_HEADERS NAMES config.h
            PATH_SUFFIXES include/NTL
            DOC "NTL headers")
endif(NTL_DIR)

if (NTL_HEADERS AND NTL_LIB)
  # Find ntl version
  file(STRINGS "${NTL_HEADERS}/version.h" NTL_VERSION REGEX "NTL_VERSION[ \t]+\"([0-9.]+)\"")
  if(NTL_VERSION)
    string(REGEX REPLACE "[^ \t]*[ \t]+NTL_VERSION[ \t]+\"([0-9.]+)\"" "\\1" NTL_VERSION ${NTL_VERSION})
  else(NTL_VERSION)
    # If the version encoding is wrong then it is set to "WRONG VERSION ENCODING" causing find_package_handle_standard_args to fail
    set(NTL_VERSION "WRONG VERSION ENCODING")
  endif(NTL_VERSION)
endif()

# Raising an error if ntl with required version has not been found
set(fail_msg "NTL required dynamic shared library has not been found. (Try cmake -DNTL_DIR=<NTL-root-path>).")
if (NTL_DIR)
  set(fail_msg "NTL required dynamic shared library has not been found in ${NTL_DIR}.")
endif(NTL_DIR)

# Check the library has been found, handle QUIET/REQUIRED arguments and set NTL_FOUND accordingly or raise the error
find_package_handle_standard_args(NTL
                                  REQUIRED_VARS NTL_LIB NTL_HEADERS
                                  VERSION_VAR NTL_VERSION
                                  FAIL_MESSAGE "${fail_msg}")

unset(fail_msg)

# If NTL has been found set the default variables
if (NTL_FOUND)
  set(NTL_LIBRARIES "${NTL_LIB}")
  set(NTL_INCLUDE_PATHS "${NTL_HEADERS}/..")
endif(NTL_FOUND)

# Mark NTL_LIBRARIES NTL_INCLUDE_PATHS as advanced variables
mark_as_advanced(NTL_LIBRARIES NTL_INCLUDE_PATHS)