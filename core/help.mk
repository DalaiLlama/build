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
	@echo "help                    You're reading it right now"
	@echo "nothing                 Check all the make files. Don't do anything though"
	@echo "showcommands            Use as a secondary make target."
	@echo "                            E.g. make all showcommands"
	@echo "                        Will display all shell commands during make"
	@echo
	@echo "Project make targets:"
	@echo "----------------------------------------------------------------------------"
	$(call print-vars,ALL_MODULES)
