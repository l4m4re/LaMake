#---------------------------------------------------------------------------
# FreeBasic
#---------------------------------------------------------------------------

# Rules for generating object files (.o).
#----------------------------------------
#.PHONY: objs.pasm

#objs.pasm:$(OBJS.pasm)

#.obj/%.o: %.pasm
#	$(COMPILE.pasm) $< -o $@

#.obj/%.o:%.pasm
#	$(COMPILE.pasm) $< -o $@

#define gen-pasm-obj
#	@echo "Compiling $< ... " $(TEE)
#	@-$(COMPILE.pasm) $< -o $@ $(OUT)
#endef

#.obj/%.o : %.pasm %.bi
#	$(gen-pasm-obj)
#.obj/%.o : %.pasm
#	$(gen-pasm-obj)
#.obj/%.o : %.pasm %.bi
#	$(gen-pasm-obj)
#.obj/%.o : %.pasm
#	$(gen-pasm-obj)

#define gen-pasm-lib-obj
#	@echo "Compiling $< ... " $(TEE)
#	@-$(COMPILE.pasm) $< -o $(TMPPREFIX)$*.o $(OUT)
##	@-$(AR) $(ARFLAGS) $@ $(TMPPREFIX)$*.o $(OUT)
#	@-$(RM) $(TMPPREFIX)$*.o
#endef

#(%.o) : %.pasm %.bi
#	$(gen-pasm-lib-obj)
#(%.o) : %.pasm
#	$(gen-pasm-lib-obj)
#(%.o) : %.pasm %.bi
#	$(gen-pasm-lib-obj)
#(%.o) : %.pasm
#	$(gen-pasm-lib-obj)



# Rules for generating the executables.
#-------------------------------------

define gen-pasm-prog
	@echo "Making $@ ... " $(TEE)
	@-$(LINK.pasm) $< $(LDLIBS.pasm) $(basename $@) $(OUT)
endef

#% : %.pasm
#	$(gen-pasm-prog)

#% : %.pasm
#	$(gen-pasm-prog)

$(strip $(BINDIR))/%.bin : %.p
	$(gen-pasm-prog)

$(strip $(BINDIR))/%.bin : %.P
	$(gen-pasm-prog)

#$(TARGETS.pasm):$(OBJS.pasm)
#	$(LINK.pasm) $(OBJS.pasm) -o $@

