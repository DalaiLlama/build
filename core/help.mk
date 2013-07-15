help:
	@echo
	@echo "Common make targets:"
	@echo "----------------------------------------------------------------------------"
	@echo "all                     All target"
	@echo "full                    All target"
	@echo "clean                   Equivalent to rm -fr out/"
	@echo "rebuild                 clean followed by a full build"
	@echo "docs                    TODO: Create all the relavent docs"
	@echo
	@echo "Helpers:"
	@echo "----------------------------------------------------------------------------"
	@echo "help                    You're reading it now"
	@echo "nothing                 Check all the make files. Don't do anything though"
	@echo "showcommands            Secondary make target to show all commands called"
	@echo "                            E.g. make all showcommands"
	@echo
	@echo "Targets found for $(PROJECT):"
	@echo "----------------------------------------------------------------------------"
	@echo "$(ALL_MODULES)"
