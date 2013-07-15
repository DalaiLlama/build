BASE_PATH := $(call my-dir)
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

#############################################################
#
#

#LOCAL_CFLAGS :=

LOCAL_SRC_FILES:= \
	libSample.cpp

#LOCAL_SHARED_LIBRARIES :=

#LOCAL_STATIC_LIBRARIES :=

#LOCAL_C_INCLUDES :=

#LOCAL_LDLIBS :=

LOCAL_MODULE:= libSample

include $(BUILD_SHARED_LIBRARY)
