#---------------------------------------------------------------------------
# FreeBasic
#---------------------------------------------------------------------------

# Rules for generating object files (.o).
#----------------------------------------
.PHONY: objs.bas

objs.bas:$(OBJS.bas)

#.obj/%.o: %.bas
#	$(COMPILE.bas) $< -o $@

#.obj/%.o:%.BAS
#	$(COMPILE.bas) $< -o $@

define gen-bas-obj
	@echo "Compiling $< ... " $(TEE)
	@-$(COMPILE.bas) $< -o $@ $(OUT)
endef

.obj/%.o : %.bas %.bi
	$(gen-bas-obj)
.obj/%.o : %.bas
	$(gen-bas-obj)
.obj/%.o : %.BAS %.bi
	$(gen-bas-obj)
.obj/%.o : %.BAS
	$(gen-bas-obj)

define gen-bas-lib-obj
	@echo "Compiling $< ... " $(TEE)
	@-$(COMPILE.bas) $< -o $(TMPPREFIX)$*.o $(OUT)
	@-$(AR) $(ARFLAGS) $@ $(TMPPREFIX)$*.o $(OUT)
	@-$(RM) $(TMPPREFIX)$*.o
endef

(%.o) : %.bas %.bi
	$(gen-bas-lib-obj)
(%.o) : %.bas
	$(gen-bas-lib-obj)
(%.o) : %.BAS %.bi
	$(gen-bas-lib-obj)
(%.o) : %.BAS
	$(gen-bas-lib-obj)



# Rules for generating the executables.
#-------------------------------------

define gen-bas-prog
	@echo "Making $@ ... " $(TEE)
	@-$(LINK.bas) -d __prog__ $< $(LDLIBS.bas) -x $@ $(OUT)
endef

#% : %.bas
#	$(gen-bas-prog)

#% : %.BAS
#	$(gen-bas-prog)

$(strip $(BINDIR))/% : %.bas
	$(gen-bas-prog)

$(strip (BINDIR))/% : %.BAS
	$(gen-bas-prog)

#$(TARGETS.bas):$(OBJS.bas)
#	$(LINK.bas) $(OBJS.bas) -o $@

# Installation

.PHONY: installinc.bas installbin.bas install.bas 

# install binaries
installbin.bas: $(INST_TARGETS_BIN.bas)

$(INST_TARGETS_BIN.bas):
	@echo "Installing FreeBasic binaries.."
	@$(MKDIR_P) $(INST_DIR_BIN.bas)
	@$(INSTALL) $(INST_FILES_BIN.bas) $(INST_DIR_BIN.bas)

# install include files
installinc.bas: $(INST_TARGETS_INC.bas)

$(INST_TARGETS_INC.bas):
	@echo "Installing FreeBasic include files.."
	@$(MKDIR_P) $(INST_DIR_INC.bas)
	@$(INSTALL) $(INST_FILES_INC.bas) $(INST_DIR_INC.bas)

install.bas: $(TARGETS.bas) installbin.bas installinc.bas




