# Don't use column under Windows, cygwin or not
COLUMN:= cat

#TODO Rmove once apc has been looked at
TARGET_ACP_UNAVAILABLE := true

ifneq (,$(findstring CYGWIN,$(UNAME)))
# TODO: Check what this should be
HOST_TOOLS_PREFIX := x86-mingw32-
else
HOST_TOOLS_PREFIX :=
endif
HOST_TOOLS_EXECUTABLE_SUFFIX := .exe

TARGET_CC := $(HOST_TOOLS_PREFIX)gcc$(HOST_TOOLS_EXECUTABLE_SUFFIX)
TARGET_CXX := $(HOST_TOOLS_PREFIX)g++$(HOST_TOOLS_EXECUTABLE_SUFFIX)
TARGET_AR := $(HOST_TOOLS_PREFIX)ar$(HOST_TOOLS_EXECUTABLE_SUFFIX)
TARGET_OBJCOPY := $(HOST_TOOLS_PREFIX)objcopy$(HOST_TOOLS_EXECUTABLE_SUFFIX)
TARGET_LD := $(HOST_TOOLS_PREFIX)ld$(HOST_TOOLS_EXECUTABLE_SUFFIX)
TARGET_STRIP := $(HOST_TOOLS_PREFIX)strip$(HOST_TOOLS_EXECUTABLE_SUFFIX)


TARGET_SHLIB_SUFFIX := .dll
TARGET_STATIC_LIB_SUFFIX := .lib
TARGET_EXECUTABLE_SUFFIX := .exe


ifeq ($(BUILD_TYPE),release)
TARGET_STRIP_COMMAND = $(TARGET_STRIP) --strip-debug $< -o $@
else
TARGET_STRIP_COMMAND = $(TARGET_STRIP) --strip-debug $< -o $@ && \
	$(TARGET_OBJCOPY) --add-gnu-debuglink=$< $@
endif

# TODO
#TARGET_GLOBAL_CFLAGS += -include $(call select-android-config-h,windows)

#TARGET_GLOBAL_LDFLAGS += --enable-stdcall-fixup
TARGET_GLOBAL_LDFLAGS += -static

# when building under Cygwin, ensure that we use Mingw compilation by default.
# you can disable this (i.e. to generate Cygwin executables) by defining the
# USE_CYGWIN variable in your environment, e.g.:
#
#   export USE_CYGWIN=1
#
# note that the -mno-cygwin flags are not needed when cross-compiling the
# Windows host tools on Linux
#
ifneq ($(findstring CYGWIN,$(UNAME)),)
ifeq ($(strip $(USE_CYGWIN)),)
TARGET_GLOBAL_CFLAGS += -mno-cygwin
TARGET_GLOBAL_LDFLAGS += -mno-cygwin -mconsole
endif
endif


define get-file-size
999999999
endef

define transform-cpp-to-o-mod
@mkdir -p $(dir $@)
@echo "target $(PRIVATE_ARM_MODE) C++: $(PRIVATE_MODULE) <= $<"
$(hide) $(PRIVATE_CXX) \
	$(addprefix -I , $(PRIVATE_C_INCLUDES)) \
	$(shell cat $(PRIVATE_IMPORT_INCLUDES)) \
	$(addprefix -isystem ,\
	    $(if $(PRIVATE_NO_DEFAULT_COMPILER_FLAGS),, \
	        $(filter-out $(PRIVATE_C_INCLUDES), \
	            $(PRIVATE_TARGET_PROJECT_INCLUDES) \
	            $(PRIVATE_TARGET_C_INCLUDES)))) \
	-c \
	$(if $(PRIVATE_NO_DEFAULT_COMPILER_FLAGS),, \
	    $(PRIVATE_TARGET_GLOBAL_CPPFLAGS) \
	    $(PRIVATE_ARM_CFLAGS) \
	 ) \
	$(PRIVATE_RTTI_FLAG) \
	$(PRIVATE_CPPFLAGS) \
	$(PRIVATE_DEBUG_CFLAGS) \
	-MD -MF $(patsubst %.o,%.d,$@) -o $@ $<
$(transform-d-to-p)
endef
define transform-o-to-executable-inner-mod
$(hide) $(PRIVATE_CXX) \
	$(PRIVATE_TARGET_GLOBAL_LDFLAGS) \
	$(PRIVATE_TARGET_GLOBAL_LD_DIRS) \
	-Wl,-rpath-link=$(TARGET_OUT_INTERMEDIATE_LIBRARIES) \
	-Wl,-rpath,\$$ORIGIN/../lib \
	$(PRIVATE_LDFLAGS) \
	$(PRIVATE_ALL_OBJECTS) \
	-Wl,--whole-archive \
	$(call normalize-target-libraries,$(PRIVATE_ALL_WHOLE_STATIC_LIBRARIES)) \
	-Wl,--no-whole-archive \
	$(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--start-group) \
	$(call normalize-target-libraries,$(PRIVATE_ALL_STATIC_LIBRARIES)) \
	$(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--end-group) \
	$(call normalize-target-libraries,$(PRIVATE_ALL_SHARED_LIBRARIES)) \
	-o $@ \
	$(PRIVATE_LDLIBS)
endef

#TARGET_GLOBAL_CFLAGS += -mstackrealign -msse3 -mfpmath=sse -m32 -march=i686 -DUSE_SSE2
#TARGET_GLOBAL_CPPFLAGS += -fno-use-cxa-atexit

## TODO: This needed? Probably
#libc_root := bionic/libc
#libm_root := bionic/libm
#libstdc++_root := bionic/libstdc++
#libthread_db_root := bionic/libthread_db
#
#TARGET_C_INCLUDES := \
#	$(libc_root)/arch-x86/include \
#	$(libc_root)/include \
#	$(libstdc++_root)/include \
#	$(libm_root)/include \
#	$(libm_root)/include/i387 \
#	$(libthread_db_root)/include


#TARGET_DEFAULT_SYSTEM_SHARED_LIBRARIES := libc libstdc++ libm

#TODO: Check
#TARGET_CUSTOM_LD_COMMAND := true
#define transform-o-to-shared-lib-inner
#$(hide) $(PRIVATE_CXX) \
#	$(PRIVATE_TARGET_GLOBAL_LDFLAGS) \
#	 -nostdlib -Wl,-soname,$(notdir $@) \
#	 -shared -Bsymbolic \
#	$(TARGET_GLOBAL_CFLAGS) \
#	$(PRIVATE_TARGET_GLOBAL_LD_DIRS) \
#	$(if $(filter true,$(PRIVATE_NO_CRT)),,$(PRIVATE_TARGET_CRTBEGIN_SO_O)) \
#	$(PRIVATE_ALL_OBJECTS) \
#	-Wl,--whole-archive \
#	$(call normalize-target-libraries,$(PRIVATE_ALL_WHOLE_STATIC_LIBRARIES)) \
#	-Wl,--no-whole-archive \
#	$(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--start-group) \
#	$(call normalize-target-libraries,$(PRIVATE_ALL_STATIC_LIBRARIES)) \
#	$(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--end-group) \
#	$(call normalize-target-libraries,$(PRIVATE_ALL_SHARED_LIBRARIES)) \
#	-o $@ \
#	$(PRIVATE_LDFLAGS) \
#	$(PRIVATE_TARGET_LIBGCC) \
#	$(if $(filter true,$(PRIVATE_NO_CRT)),,$(PRIVATE_TARGET_CRTEND_SO_O))
#endef
#
#define transform-o-to-executable-inner
#$(hide) $(PRIVATE_CXX) \
#	$(PRIVATE_TARGET_GLOBAL_LDFLAGS) \
#	-nostdlib -Bdynamic \
#	-Wl,-dynamic-linker,/system/bin/linker \
#	-Wl \
#	-fPIE -pie \
#	-o $@ \
#	$(PRIVATE_TARGET_GLOBAL_LD_DIRS) \
#	-Wl,-rpath-link=$(TARGET_OUT_INTERMEDIATE_LIBRARIES) \
#	$(call normalize-target-libraries,$(PRIVATE_ALL_SHARED_LIBRARIES)) \
#	$(if $(filter true,$(PRIVATE_NO_CRT)),,$(PRIVATE_TARGET_CRTBEGIN_DYNAMIC_O)) \
#	$(PRIVATE_ALL_OBJECTS) \
#	-Wl,--whole-archive \
#	$(call normalize-target-libraries,$(PRIVATE_ALL_WHOLE_STATIC_LIBRARIES)) \
#	-Wl,--no-whole-archive \
#	$(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--start-group) \
#	$(call normalize-target-libraries,$(PRIVATE_ALL_STATIC_LIBRARIES)) \
#	$(if $(PRIVATE_GROUP_STATIC_LIBRARIES),-Wl$(comma)--end-group) \
#	$(PRIVATE_LDFLAGS) \
#	$(PRIVATE_TARGET_LIBGCC) \
#	$(if $(filter true,$(PRIVATE_NO_CRT)),,$(PRIVATE_TARGET_CRTEND_O))
#endef
#
#define transform-o-to-static-executable-inner
#$(hide) $(PRIVATE_CXX) \
#	$(PRIVATE_TARGET_GLOBAL_LDFLAGS) \
#	-nostdlib -Bstatic \
#	-o $@ \
#	$(PRIVATE_TARGET_GLOBAL_LD_DIRS) \
#	$(if $(filter true,$(PRIVATE_NO_CRT)),,$(PRIVATE_TARGET_CRTBEGIN_STATIC_O)) \
#	$(PRIVATE_LDFLAGS) \
#	$(PRIVATE_ALL_OBJECTS) \
#	-Wl,--whole-archive \
#	$(call normalize-target-libraries,$(PRIVATE_ALL_WHOLE_STATIC_LIBRARIES)) \
#	-Wl,--no-whole-archive \
#	-Wl,--start-group \
#	$(call normalize-target-libraries,$(PRIVATE_ALL_STATIC_LIBRARIES)) \
#	$(PRIVATE_TARGET_LIBGCC) \
#	-Wl,--end-group \
#	$(if $(filter true,$(PRIVATE_NO_CRT)),,$(PRIVATE_TARGET_CRTEND_O))
#endef
