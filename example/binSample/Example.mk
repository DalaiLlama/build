BASE_PATH := $(call my-dir)
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

#############################################################
#
#

#DEBUG_MODULE_$(strip $(LOCAL_MODULE)) := true

LOCAL_SRC_FILES:= \
    main.cpp

LOCAL_C_INCLUDES := \
    libSample/

LOCAL_SHARED_LIBRARIES := \
    libSample

LOCAL_STATIC_LIBRARIES :=

LOCAL_LDLIBS :=

LOCAL_CFLAGS :=

LOCAL_MODULE:= sample

include $(BUILD_EXECUTABLE)
