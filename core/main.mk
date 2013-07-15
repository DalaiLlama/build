$(info ::::::::::::::::::::::::::::::: Parsing make files START :::::::::::::::::::::::::::::::)
# TODO? Needed?
SHELL := /bin/bash

# Absolute path of the present working direcotry.
# This overrides the shell variable $PWD, which does not necessarily points to
# the top of the source tree, for example when "make -C" is used in m/mm/mmm.
PWD := $(shell pwd)
TOP := .
TOPDIR :=

include $(BUILD_SYSTEM)/debug.mk

.PHONY: default
default: help

# Set up the bulld environment
include $(BUILD_SYSTEM)/setup.mk

# These targets don't build anything
SKIP_COMMAND_GOALS := clean

ifeq ($(filter $(MAKECMDGOALS),$(SKIP_COMMAND_GOALS)),)
$(call print-setup-info)

# Generic build tools
include $(BUILD_SYSTEM)/definitions.mk

#
# Typical build; include any Project.mk files we can find.
#
subdirs := $(TOP)

ifneq ($(ONE_SHOT_MAKEFILE),)

include $(ONE_SHOT_MAKEFILE)
# Change CUSTOM_MODULES to include only modules that were
# defined by this makefile; this will install all of those
# modules as a side-effect.  Do this after including ONE_SHOT_MAKEFILE
# so that the modules will be installed in the same place they
# would have been with a normal make.
CUSTOM_MODULES := $(sort $(call get-tagged-modules,$(ALL_MODULE_TAGS)))
FULL_BUILD :=
# Stub out the notice targets, which probably aren't defined
# when using ONE_SHOT_MAKEFILE.
NOTICE-HOST-%: ;
NOTICE-TARGET-%: ;

else
#
# Include all of the makefiles in the system
#

# Can't use first-makefiles-under here because
# --mindepth=2 makes the prunes not work.

subdir_makefiles := \
	$(shell $(BUILD_SYSTEM)/../tools/findleaves.py --prune=out --prune=.repo --prune=.git $(subdirs) $(PROJECT).mk)

# TODO Better way to handle windows file system. Possible in findleaves.py?
include $(subst \,/,$(subdir_makefiles))

endif # ONE_SHOT_MAKEFILE

# -------------------------------------------------------------------
# Define dependencies for modules that require other modules.
# This can only happen now, after we've read in all module makefiles.
#
#define add-required-deps
#$(1): $(2)
#endef
#
#$(foreach m,$(ALL_MODULES), \
#  $(eval r := $(ALL_MODULES.$(m).REQUIRED)) \
#  $(if $(r), \
#    $(eval r := $(call module-installed-files,$(r))) \
#    $(eval $(call add-required-deps,$(ALL_MODULES.$(m).INSTALLED),$(r))) \
#   ) \
# )
#m :=
#r :=
#i :=
#add-required-deps :=

$(foreach m,$(ALL_MODULES), \
  $(eval r := $(ALL_MODULES.$(m).REQUIRED)) \
  $(if $(r), \
    $(eval r := $(call module-installed-files,$(r))) \
    $(eval $(call add-dependency,$(ALL_MODULES.$(m).INSTALLED),$(r))) \
   ) \
 )
m :=
r :=
i :=
add-dependency:=


# -------------------------------------------------------------------
# Figure out our module sets.
#
# Of the modules defined by the component makefiles,
# determine what we actually want to build.

# The base list of modules to build for this product is specified
# by the appropriate product definition file, which was included
# by product_config.make.
product_MODULES := $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_PACKAGES)
# Filter out the overridden packages before doing expansion
product_MODULES := $(filter-out $(foreach p, $(product_MODULES), \
    $(PACKAGES.$(p).OVERRIDES)), $(product_MODULES))
$(call expand-required-modules,product_MODULES,$(product_MODULES))
product_FILES := $(call module-installed-files, $(product_MODULES))
ifeq (0,1)
    $(info product_FILES for $(TARGET_DEVICE) ($(INTERNAL_PRODUCT)):)
    $(foreach p,$(product_FILES),$(info :   $(p)))
    $(error done)
endif

# When modules are tagged with debug eng or tests, they are installed
# for those variants regardless of what the product spec says.
debug_MODULES := $(sort \
        $(call get-tagged-modules,debug) \
        $(call module-installed-files, $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_PACKAGES_DEBUG)) \
    )

eng_MODULES := $(sort \
        $(call get-tagged-modules,eng) \
        $(call module-installed-files, $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_PACKAGES_ENG)) \
    )

tests_MODULES := $(sort \
        $(call get-tagged-modules,tests) \
        $(call module-installed-files, $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_PACKAGES_TESTS)) \
    )

# TODO: Remove the 3 places in the tree that use ALL_DEFAULT_INSTALLED_MODULES
# and get rid of it from this list.
# TODO: The shell is chosen by magic.  Do we still need this?
modules_to_install := $(sort \
    $(ALL_DEFAULT_INSTALLED_MODULES) \
    $(product_FILES) \
    $(foreach tag,$(tags_to_install),$($(tag)_MODULES)) \
    $(call get-tagged-modules, shell_$(TARGET_SHELL)) \
    $(CUSTOM_MODULES) \
  )

# Some packages may override others using LOCAL_OVERRIDES_PACKAGES.
# Filter out (do not install) any overridden packages.
overridden_packages := $(call get-package-overrides,$(modules_to_install))
ifdef overridden_packages
#  old_modules_to_install := $(modules_to_install)
  modules_to_install := \
      $(filter-out $(foreach p,$(overridden_packages),$(p) %/$(p).apk), \
          $(modules_to_install))
endif


# Install all of the host modules
modules_to_install += $(sort $(modules_to_install) $(ALL_HOST_INSTALLED_FILES))


# build/core/Makefile contains extra stuff that we don't want to pollute this
# top-level makefile with.  It expects that ALL_DEFAULT_INSTALLED_MODULES
# contains everything that's built during the current make, but it also further
# extends ALL_DEFAULT_INSTALLED_MODULES.
ALL_DEFAULT_INSTALLED_MODULES := $(modules_to_install)

#TODO: Why are there two of the same module>

modules_to_install := $(sort $(ALL_DEFAULT_INSTALLED_MODULES))

ALL_DEFAULT_INSTALLED_MODULES :=

endif # skip

.PHONY: help
include $(BUILD_SYSTEM)/help.mk

.PHONY: showcommands
showcommands:
	@echo >/dev/null

.PHONY: rebuild
rebuild: clean full

.PHONY: all
all: full

.PHONY: full
full: $(ALL_MODULES)

.PHONY: clean
ifneq ($(OUT_DIR),out)
clean:
	@echo "Something's gone so very very wrong..."
	@echo "You almost deleted the working directory!!"
else
clean:
	@rm -fr $(OUT_DIR)
	@echo "Entire build directory removed."
endif

.PHONY: nothing
nothing:
	@echo Successfully read the makefiles.


$(info :::::::::::::::::::::::::::::::: Parsing make files END ::::::::::::::::::::::::::::::::)
