BASE_PATH := $(call my-dir)
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

$(info Monads.mk)


#LOCAL_CFLAGS +=

#LOCAL_SRC_FILES:= \
#	main.cpp

#LOCAL_SHARED_LIBRARIES :=

#LOCAL_STATIC_LIBRARIES :=

#LOCAL_C_INCLUDES +=

#LOCAL_LDLIBS +=

LOCAL_MODULE:= test

include $(BUILD_EXECUTABLE)



#############################################################
# Build the tests
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	third_party/glu/libtess/dict.c \
	third_party/glu/libtess/geom.c \
	third_party/glu/libtess/memalloc.c \
	third_party/glu/libtess/mesh.c \
	third_party/glu/libtess/normal.c \
	third_party/glu/libtess/priorityq.c \
	third_party/glu/libtess/render.c \
	third_party/glu/libtess/sweep.c \
	third_party/glu/libtess/tess.c \
	third_party/glu/libtess/tessmono.c

#LOCAL_SHARED_LIBRARIES :=

#LOCAL_C_INCLUDES +=

#LOCAL_LDLIBS += -lpthread

LOCAL_MODULE:= libprojecttest
LOCAL_MODULE_TAGS := optional

include $(BUILD_STATIC_LIBRARY)

#############################################################
