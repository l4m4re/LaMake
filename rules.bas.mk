#---------------------------------------------------------------------------
# FreeBasic
#---------------------------------------------------------------------------

# Rules for generating the executables.
#-------------------------------------

$(TARGETS.bas):$(OBJS.bas)
	$(LINK.bas) $(OBJS.bas) -o $@



# Rules for generating object files (.o).
#----------------------------------------
#objs:$(OBJS)

.obj/%.o: %.bas
	$(COMPILE.bas) $< -o $@

.obj/%.o:%.BAS
	$(COMPILE.bas) $< -o $@

