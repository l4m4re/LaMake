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

$(BINDIR)/% : %.bas
	$(gen-bas-prog)

$(BINDIR)/% : %.BAS
	$(gen-bas-prog)

#$(TARGETS.bas):$(OBJS.bas)
#	$(LINK.bas) $(OBJS.bas) -o $@

