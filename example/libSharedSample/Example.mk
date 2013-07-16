BASE_PATH := $(call my-dir)
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

###############################
# libShared
#

LOCAL_MODULE:= libShared

LOCAL_SRC_FILES:= \
	libShared.cpp

#LOCAL_C_INCLUDES :=

#LOCAL_SHARED_LIBRARIES :=

#LOCAL_STATIC_LIBRARIES :=

#LOCAL_CFLAGS :=

#LOCAL_LDLIBS :=

include $(BUILD_SHARED_LIBRARY)
