BASE_PATH := $(call my-dir)
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

###############################
# libStatic
#
LOCAL_MODULE_SUFFIX := .lib

LOCAL_MODULE := libStatic

LOCAL_SRC_FILES:= \
	libStatic.cpp

#LOCAL_C_INCLUDES :=

#LOCAL_SHARED_LIBRARIES :=

#LOCAL_STATIC_LIBRARIES :=

#LOCAL_CFLAGS :=

#LOCAL_LDLIBS :=

include $(BUILD_STATIC_LIBRARY)
