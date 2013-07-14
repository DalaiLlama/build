# The 'showcommands' goal says to show the full command
# lines being executed, instead of a short message about
# the kind of operation being done.
SHOW_COMMANDS:= $(filter showcommands,$(MAKECMDGOALS))
ifeq ($(strip $(SHOW_COMMANDS)),)
define pretty
@echo $1
endef
hide := @
else
define pretty
endef
hide :=
endif

###########################################################
## Debugging; prints a variable list to stdout
###########################################################

# Extra debugging information
define print
$(info $1 = $($1))
endef

define print-var
$(info $1 = $($1))
endef

# $(1): variable name list, not variable values
define print-vars
$(foreach var,$(1), \
  $(info $(var):) \
  $(foreach word,$($(var)), \
    $(info $(space)$(space)$(word)) \
   ) \
 )
endef


#DEBUG := true
ifeq ($(DEBUG),true)
define print-setup-info
$(info ************************* Setup info *************************) \
$(call print,BUILD_NUMBER) \
$(call print,TARGET_OS) \
$(call print,TARGET_ARCH) \
$(call print,TARGET_GLOBAL_CFLAGS) \
$(call print,TARGET_GLOBAL_CPPFLAGS) \
$(call print,TARGET_GLOBAL_LDFLAGS) \
$(call print,TARGET_GLOBAL_ARFLAGS) \
$(call print,TARGET_GLOBAL_LD_DIRS) \
$(call print,TARGET_C_INCLUDES) \
$(call print,TARGET_STRIP_COMMAND) \
$(call print,TARGET_DEFAULT_SYSTEM_SHARED_LIBRARIES) \
$(info **************************************************************)
endef

define print-out-dir-info
$(info ************************* Local info *************************) \
$(call print,) \
$(call print,) \
$(call print,) \
$(call print,) \
$(call print,) \
$(call print,) \
$(call print,) \
$(call print,) \
$(info **************************************************************)
endef

define print-local-info
$(info ************************* Local info *************************) \
$(call print,LOCAL_CLANG) \
$(call print,LOCAL_CFLAGS) \
$(call print,LOCAL_CPPFLAGS) \
$(call print,LOCAL_LDFLAGS) \
$(call print,LOCAL_LDLIBS) \
$(call print,LOCAL_SHARED_LIBRARIES) \
$(call print,LOCAL_STATIC_LIBRARIES) \
$(call print,LOCAL_IS_HOST_MODULE) \
$(call print,LOCAL_SYSTEM_SHARED_LIBRARIES) \
$(call print,LOCAL_SHARED_LIBRARIES) \
$(call print,LOCAL_STATIC_LIBRARIES) \
$(call print,LOCAL_WHOLE_STATIC_LIBRARIES) \
$(call print,LOCAL_REQUIRED_MODULES) \
$(info **************************************************************)
endef

define print-private-target-info
$(info ************************ Target info *************************) \
$(call print,TARGET_GLOBAL_LD_DIRS) \
$(call print,TARGET_GLOBAL_LDFLAGS) \
$(call print,TARGET_FDO_LIB) \
$(call print,TARGET_LIBGCC) \
$(call print,TARGET_CRTBEGIN_DYNAMIC_O) \
$(call print,TARGET_CRTBEGIN_STATIC_O) \
$(call print,TARGET_CRTEND_O) \
$(info **************************************************************)
endef

define print-private-target-info
$(info ******************** Private target info *********************) \
$(call print,PRIVATE_TARGET_GLOBAL_LD_DIRS) \
$(call print,PRIVATE_TARGET_GLOBAL_LDFLAGS) \
$(call print,PRIVATE_TARGET_FDO_LIB) \
$(call print,PRIVATE_TARGET_LIBGCC) \
$(call print,PRIVATE_TARGET_CRTBEGIN_DYNAMIC_O) \
$(call print,PRIVATE_TARGET_CRTBEGIN_STATIC_O) \
$(call print,PRIVATE_TARGET_CRTEND_O) \
$(info **************************************************************)
endef
endif # DEBUG
