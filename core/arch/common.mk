# ###############################################################
# Set common values
# ###############################################################

# Message formatting
COMMON_GLOBAL_CFLAGS := -fmessage-length=0
# Inhibit all warning messages.
COMMON_GLOBAL_CFLAGS += -W
# Make all warnings into errors.
COMMON_GLOBAL_CFLAGS += -Wall
# Do not warn on unsed-* warnings
COMMON_GLOBAL_CFLAGS += -Wno-unused
# Warn about uninitialized variables which are initialized with themselves
COMMON_GLOBAL_CFLAGS += -Winit-self
# Warn about anything that depends on the size of a function type or of void.
COMMON_GLOBAL_CFLAGS += -Wpointer-arith

# Use all common c flags
COMMON_GLOBAL_CPPFLAGS := $(COMMON_GLOBAL_CFLAGS)
# Warn when overload resolution chooses a promotion from unsigned or enumerated
# type to a signed type, over a conversion to an unsigned type of the same
# size.
COMMON_GLOBAL_CPPFLAGS += -Wsign-promo
# list of flags to turn specific warnings in to errors




TARGET_ERROR_FLAGS := -Werror=return-type -Werror=non-virtual-dtor -Werror=address -Werror=sequence-point


TARGET_GLOBAL_CFLAGS += $(COMMON_GLOBAL_CFLAGS) $(TARGET_ERROR_FLAGS)
# Do not support stack unwinding with try and catch blocks and the throw
# keyword.
TARGET_GLOBAL_CFLAGS += -Wno-multichar
TARGET_GLOBAL_CFLAGS += -fno-exceptions
TARGET_GLOBAL_CFLAGS += -fno-strict-aliasing
TARGET_GLOBAL_CFLAGS += -O2
TARGET_GLOBAL_CFLAGS += -g



TARGET_GLOBAL_CPPFLAGS := $(COMMON_GLOBAL_CPPFLAGS) $(TARGET_ERROR_FLAGS)

TARGET_GLOBAL_LDFLAGS :=

TARGET_GLOBAL_ARFLAGS := crsP


TARGET_HAVE_EXCEPTIONS := 0
TARGET_HAVE_UNIX_FILE_PATH := 1
TARGET_HAVE_WINDOWS_FILE_PATH := 0
TARGET_HAVE_RTTI := 1
TARGET_HAVE_CALL_STACKS := 1
TARGET_HAVE_64BIT_IO := 1
TARGET_HAVE_CLOCK_TIMERS := 1
TARGET_HAVE_PTHREAD_RWLOCK := 1
TARGET_HAVE_STRNLEN := 1
TARGET_HAVE_STRERROR_R_STRRET := 1
TARGET_HAVE_STRLCPY := 0
TARGET_HAVE_STRLCAT := 0
TARGET_HAVE_KERNEL_MODULES := 0
