BASE_PATH := $(call my-dir)
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

###############################
# sample
#

LOCAL_MODULE:= sample

LOCAL_SRC_FILES:= \
    main.cpp

LOCAL_C_INCLUDES := \
    libSharedSample/ \
    libStaticSample/

LOCAL_SHARED_LIBRARIES := \
    libShared

LOCAL_STATIC_LIBRARIES := \
    libStatic

#LOCAL_LDLIBS :=

#LOCAL_CFLAGS :=

#DEBUG_MODULE_$(strip $(LOCAL_MODULE)) := true

include $(BUILD_EXECUTABLE)
