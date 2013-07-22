###########################################################
## Standard rules for building an executable file.
##
## Additional inputs from base_rules.make:
## None.
###########################################################

ifeq ($(strip $(LOCAL_MODULE_CLASS)),)
LOCAL_MODULE_CLASS := EXECUTABLES
endif
ifeq ($(strip $(LOCAL_MODULE_SUFFIX)),)
LOCAL_MODULE_SUFFIX := $(TARGET_EXECUTABLE_SUFFIX)
endif

####################################################
## Add profiling libraries if aprof is turned
####################################################
ifeq ($(strip $(LOCAL_ENABLE_APROF)),true)
  ifeq ($(LOCAL_FORCE_STATIC_EXECUTABLE), true)
    LOCAL_STATIC_LIBRARIES += libaprof libaprof_static libc libcutils
  else
    LOCAL_SHARED_LIBRARIES += libaprof libaprof_runtime libc
  endif
  LOCAL_WHOLE_STATIC_LIBRARIES += libaprof_aux
endif

include $(BUILD_SYSTEM)/dynamic_binary.mk

# Define PRIVATE_ variables from global vars
my_target_global_ld_dirs := $(TARGET_GLOBAL_LD_DIRS)
my_target_global_ldflags := $(TARGET_GLOBAL_LDFLAGS)
my_target_fdo_lib := $(TARGET_FDO_LIB)
my_target_libgcc := $(TARGET_LIBGCC)
my_target_crtbegin_dynamic_o := $(TARGET_CRTBEGIN_DYNAMIC_O)
my_target_crtbegin_static_o := $(TARGET_CRTBEGIN_STATIC_O)
my_target_crtend_o := $(TARGET_CRTEND_O)

$(linked_module): PRIVATE_TARGET_GLOBAL_LD_DIRS := $(my_target_global_ld_dirs)
$(linked_module): PRIVATE_TARGET_GLOBAL_LDFLAGS := $(my_target_global_ldflags)
$(linked_module): PRIVATE_TARGET_FDO_LIB := $(my_target_fdo_lib)
$(linked_module): PRIVATE_TARGET_LIBGCC := $(my_target_libgcc)
$(linked_module): PRIVATE_TARGET_CRTBEGIN_DYNAMIC_O := $(my_target_crtbegin_dynamic_o)
$(linked_module): PRIVATE_TARGET_CRTBEGIN_STATIC_O := $(my_target_crtbegin_static_o)
$(linked_module): PRIVATE_TARGET_CRTEND_O := $(my_target_crtend_o)

ifeq ($(LOCAL_FORCE_STATIC_EXECUTABLE),true)
$(linked_module): $(my_target_crtbegin_static_o) $(all_objects) $(all_libraries) $(my_target_crtend_o)
	$(transform-o-to-static-executable)
else
$(linked_module): $(my_target_crtbegin_dynamic_o) $(all_objects) $(all_libraries) $(my_target_crtend_o)
	$(transform-o-to-executable)
endif
