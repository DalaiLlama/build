BASE_PATH := $(call my-dir)
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

$(info ##############)
$(info # Project.mk #)
$(info ##############)

#############################################################
#
#

#LOCAL_CFLAGS +=

LOCAL_SRC_FILES:= \
	main.cpp

#LOCAL_SHARED_LIBRARIES :=

#LOCAL_STATIC_LIBRARIES :=

#LOCAL_C_INCLUDES +=

#LOCAL_LDLIBS +=

LOCAL_MODULE:= main

include $(BUILD_EXECUTABLE)
