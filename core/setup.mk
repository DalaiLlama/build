# ###############################################################
# Check build dependencies.
# ###############################################################
python := $(shell which python)
python_min := 3.0.0
ifeq ($(python),)
$(warning **************************************************************)
$(warning **************************************************************)
$(warning Python can not be found)
$(warning Please make sure it is available in the path)
$(warning The minimum supported version is $(python_min))
$(warning **************************************************************)
$(warning **************************************************************)
$(error stopping)
else
python_version := $(shell python --version 2>&1 | sed 's/^.* //g')
python_valid := $(shell $(BUILD_SYSTEM)/../tools/checkversion.py --min=$(python_min) --version=$(python_version))
ifneq ($(python_valid),True)
$(warning **************************************************************)
$(warning **************************************************************)
$(warning Uncompatable python version $(python_version))
$(warning Please install $(python_min) or later)
$(warning **************************************************************)
$(warning **************************************************************)
$(error stopping)
endif
endif

# ###############################################################
# Utility variables.
# ###############################################################
empty :=
space := $(empty) $(empty)
comma := ,

# ###############################################################
# Build environment
# ###############################################################
BUILD_TYPES := release debug

# Default build type as debug
ifeq ($(strip $(BUILD_TYPE)),)
BUILD_TYPE := debug
else
ifneq ($(filter $(BUILD_TYPE),$(MAKECMDGOALS)),)
$(warning **************************************************************)
$(warning **************************************************************)
$(warning Do not pass '$(filter $(BUILD_TYPES),$(MAKECMDGOALS))' on \
		the make command line.)
$(warning Set BUILD_TYPES in buildspec.mk)
$(warning **************************************************************)
$(warning **************************************************************)
$(error stopping)
endif
ifeq ($(filter $(BUILD_TYPE),$(BUILD_TYPES)),)
$(warning **************************************************************)
$(warning **************************************************************)
$(warning bad BUILD_TYPE: $(BUILD_TYPE))
$(warning must be empty or one of: $(BUILD_TYPES))
$(warning **************************************************************)
$(warning **************************************************************)
$(error stopping)
endif
endif

BUILD_NUMBER := $(BUILD_TYPE).$(shell date +%Y%m%d.%H%M%S)

#TODO - Find unique name for each varient
UNAME := $(shell uname -sm)

# HOST_OS
ifneq (,$(findstring Linux,$(UNAME)))
	HOST_OS := linux
endif
ifneq (,$(findstring Darwin,$(UNAME)))
	HOST_OS := darwin
endif
ifneq (,$(findstring Macintosh,$(UNAME)))
	HOST_OS := darwin
endif
ifneq (,$(findstring CYGWIN,$(UNAME)))
	HOST_OS := windows
endif
ifneq (,$(findstring MINGW32_NT,$(UNAME)))
	HOST_OS := windows
endif

ifeq ($(HOST_OS),)
$(error Unable to determine HOST_OS from uname -sm: $(UNAME)!)
endif

# HOST_ARCH
ifneq (,$(findstring 64,$(UNAME)))
	HOST_ARCH := x86_64
else ifneq (,$(findstring 86,$(UNAME)))
	HOST_ARCH := x86
else ifneq (,$(findstring Power,$(UNAME)))
	HOST_ARCH := ppc
endif

ifeq ($(HOST_ARCH),)
$(error Unable to determine HOST_ARCH from uname -sm: $(UNAME)!)
endif

# Default TARGET_OS as the HOST_OS
ifeq ($(TARGET_OS),)
	TARGET_OS := $(HOST_OS)
endif

# Default TARGET_ARCH as the HOST_ARCH
ifeq ($(TARGET_ARCH),)
	TARGET_ARCH := $(HOST_ARCH)
endif



# ###############################################################
# Build flags
# ###############################################################
include $(BUILD_SYSTEM)/arch/common.mk

# Build a target string like "linux-arm" or "darwin-x86".

include $(BUILD_SYSTEM)/arch/$(TARGET_OS)-$(TARGET_ARCH).mk

# ###############################################################
# Figure out the output directories
# ###############################################################

ifeq (,$(strip $(OUT_DIR)))
ifeq (,$(strip $(OUT_DIR_COMMON_BASE)))
OUT_DIR := $(TOPDIR)out
else
OUT_DIR := $(OUT_DIR_COMMON_BASE)/$(notdir $(PWD))
endif
endif

# TODO: Tidy up

# TARGET_COPY_OUT_* are all relative to the staging directory, ie PRODUCT_OUT.
# Define them here so they can be used in product config files.
TARGET_COPY_OUT_DATA := data
TARGET_COPY_OUT_ROOT := root
TARGET_COPY_OUT_RECOVERY := recovery


# TARGET_COPY_OUT_* are all relative to the staging directory, ie PRODUCT_OUT.
# Define them here so they can be used in product config files.
TARGET_COPY_OUT_SYSTEM := system
TARGET_COPY_OUT_DATA := data
TARGET_COPY_OUT_VENDOR := system/vendor
TARGET_COPY_OUT_ROOT := root
TARGET_COPY_OUT_RECOVERY := recovery


TARGET_OUT_ROOT_release := $(OUT_DIR)/release
TARGET_OUT_ROOT_debug := $(OUT_DIR)

PRODUCT_OUT := $(TARGET_OUT_ROOT_$(BUILD_TYPE))

TARGET_COMMON_OUT_ROOT := $(PRODUCT_OUT)/common

OUT_DOCS := $(TARGET_COMMON_OUT_ROOT)/docs

BUILD_OUT_EXECUTABLES:= $(OUT_DIR)/bin

TARGET_OUT_INTERMEDIATES := $(PRODUCT_OUT)/obj
TARGET_OUT_HEADERS:= $(TARGET_OUT_INTERMEDIATES)/include
TARGET_OUT_INTERMEDIATE_LIBRARIES := $(TARGET_OUT_INTERMEDIATES)/lib
TARGET_OUT_COMMON_INTERMEDIATES := $(TARGET_COMMON_OUT_ROOT)/obj

TARGET_OUT := $(PRODUCT_OUT)
TARGET_OUT_EXECUTABLES:= $(TARGET_OUT)/bin
TARGET_OUT_SHARED_LIBRARIES:= $(TARGET_OUT)/bin
TARGET_OUT_ETC := $(TARGET_OUT)/etc
TARGET_OUT_NOTICE_FILES:=$(TARGET_OUT_INTERMEDIATES)/NOTICE_FILES

TARGET_OUT_DATA := $(PRODUCT_OUT)/$(TARGET_COPY_OUT_DATA)
TARGET_OUT_DATA_EXECUTABLES:= $(TARGET_OUT_EXECUTABLES)
TARGET_OUT_DATA_SHARED_LIBRARIES:= $(TARGET_OUT_SHARED_LIBRARIES)
TARGET_OUT_DATA_JAVA_LIBRARIES:= $(TARGET_OUT_JAVA_LIBRARIES)
TARGET_OUT_DATA_APPS:= $(TARGET_OUT_DATA)/app
TARGET_OUT_DATA_KEYLAYOUT := $(TARGET_OUT_KEYLAYOUT)
TARGET_OUT_DATA_KEYCHARS := $(TARGET_OUT_KEYCHARS)
TARGET_OUT_DATA_ETC := $(TARGET_OUT_ETC)
TARGET_OUT_DATA_NATIVE_TESTS := $(TARGET_OUT_DATA)/nativetest

TARGET_OUT_CACHE := $(PRODUCT_OUT)/cache

TARGET_OUT_VENDOR := $(PRODUCT_OUT)
TARGET_OUT_VENDOR_EXECUTABLES:= $(TARGET_OUT_VENDOR)/bin
TARGET_OUT_VENDOR_SHARED_LIBRARIES:= $(TARGET_OUT_VENDOR)/lib
TARGET_OUT_VENDOR_APPS:= $(TARGET_OUT_VENDOR)/app
TARGET_OUT_VENDOR_ETC := $(TARGET_OUT_VENDOR)/etc

TARGET_OUT_UNSTRIPPED := $(PRODUCT_OUT)/symbols
TARGET_OUT_EXECUTABLES_UNSTRIPPED := $(TARGET_OUT_UNSTRIPPED)/bin
TARGET_OUT_SHARED_LIBRARIES_UNSTRIPPED := $(TARGET_OUT_UNSTRIPPED)/bin
TARGET_ROOT_OUT_UNSTRIPPED := $(TARGET_OUT_UNSTRIPPED)
TARGET_ROOT_OUT_SBIN_UNSTRIPPED := $(TARGET_OUT_UNSTRIPPED)/sbin
TARGET_ROOT_OUT_BIN_UNSTRIPPED := $(TARGET_OUT_UNSTRIPPED)/bin

TARGET_ROOT_OUT := $(PRODUCT_OUT)/$(TARGET_COPY_OUT_ROOT)
TARGET_ROOT_OUT_BIN := $(TARGET_ROOT_OUT)/bin
TARGET_ROOT_OUT_SBIN := $(TARGET_ROOT_OUT)/sbin
TARGET_ROOT_OUT_ETC := $(TARGET_ROOT_OUT)/etc
TARGET_ROOT_OUT_USR := $(TARGET_ROOT_OUT)/usr

TARGET_RECOVERY_OUT := $(PRODUCT_OUT)/$(TARGET_COPY_OUT_RECOVERY)
TARGET_RECOVERY_ROOT_OUT := $(TARGET_RECOVERY_OUT)/root

TARGET_SYSLOADER_OUT := $(PRODUCT_OUT)/sysloader
TARGET_SYSLOADER_ROOT_OUT := $(TARGET_SYSLOADER_OUT)/root
TARGET_SYSLOADER_SYSTEM_OUT := $(TARGET_SYSLOADER_OUT)/root/system

TARGET_INSTALLER_OUT := $(PRODUCT_OUT)/installer
TARGET_INSTALLER_DATA_OUT := $(TARGET_INSTALLER_OUT)/data
TARGET_INSTALLER_ROOT_OUT := $(TARGET_INSTALLER_OUT)/root
TARGET_INSTALLER_SYSTEM_OUT := $(TARGET_INSTALLER_OUT)/root/system

ifeq (,$(strip $(DIST_DIR)))
  DIST_DIR := $(OUT_DIR)/dist
endif

ifeq ($(PRINT_BUILD_CONFIG),)
PRINT_BUILD_CONFIG := true
endif

# ###############################################################
# Build system internal files
# ###############################################################
CLEAR_VARS := $(BUILD_SYSTEM)/clear_vars.mk
BUILD_EXECUTABLE := $(BUILD_SYSTEM)/executable.mk
BUILD_SHARED_LIBRARY := $(BUILD_SYSTEM)/shared_library.mk
BUILD_STATIC_LIBRARY := $(BUILD_SYSTEM)/static_library.mk


# TODO Enable and check
#ifneq ($(USE_CCACHE),)
#  # The default check uses size and modification time, causing false misses
#  # since the mtime depends when the repo was checked out
#  export CCACHE_COMPILERCHECK := content
#
#  # See man page, optimizations to get more cache hits
#  # implies that __DATE__ and __TIME__ are not critical for functionality.
#  # Ignore include file modification time since it will depend on when
#  # the repo was checked out
#  export CCACHE_SLOPPINESS := time_macros,include_file_mtime,file_macro
#
#  # Turn all preprocessor absolute paths into relative paths.
#  # Fixes absolute paths in preprocessed source due to use of -g.
#  # We don't really use system headers much so the rootdir is
#  # fine; ensures these paths are relative for all Android trees
#  # on a workstation.
#  export CCACHE_BASEDIR := /
#
#  CCACHE_HOST_TAG := $(HOST_PREBUILT_TAG)
#  # If we are cross-compiling Windows binaries on Linux
#  # then use the linux ccache binary instead.
#  ifeq ($(HOST_OS)-$(BUILD_OS),windows-linux)
#    CCACHE_HOST_TAG := linux-$(BUILD_ARCH)
#  endif
#  ccache := prebuilts/misc/$(CCACHE_HOST_TAG)/ccache/ccache
#  # Check that the executable is here.
#  ccache := $(strip $(wildcard $(ccache)))
#  ifdef ccache
#    # prepend ccache if necessary
#    ifneq ($(ccache),$(firstword $(TARGET_CC)))
#      TARGET_CC := $(ccache) $(TARGET_CC)
#    endif
#    ifneq ($(ccache),$(firstword $(TARGET_CXX)))
#      TARGET_CXX := $(ccache) $(TARGET_CXX)
#    endif
#    ccache =
#  endif
#endif
