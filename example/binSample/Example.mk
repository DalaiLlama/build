BASE_PATH := $(call my-dir)
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= main.cpp

LOCAL_SHARED_LIBRARIES :=

LOCAL_STATIC_LIBRARIES :=

LOCAL_C_INCLUDES +=

LOCAL_LDLIBS +=

LOCAL_CFLAGS +=

LOCAL_MODULE:= exmaple

#DEBUG_MODULE_$(strip $(LOCAL_MODULE)) := true

include $(BUILD_EXECUTABLE)