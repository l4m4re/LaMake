
# TODO: make python script for generating this file.

# Rules for creating dependency files (.d).
#------------------------------------------

#deps:$(DEPS)

.obj/%.d:%.c
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

.obj/%.d:%.C
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

.obj/%.d:%.cc
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

.obj/%.d:%.cpp
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

.obj/%.d:%.CPP
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

.obj/%.d:%.c++
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

.obj/%.d:%.cp
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

.obj/%.d:%.cxx
	@echo -n $(dir $<) > $@
	@$(DEPEND.d) $< >> $@

# Rules for generating object files (.o).
#----------------------------------------
#objs:$(OBJS)

.obj/%.o: %.c
	$(COMPILE.c) $< -o $@

.obj/%.o:%.C
	$(COMPILE.cxx) $< -o $@

.obj/%.o:%.cc
	$(COMPILE.cxx) $< -o $@

.obj/%.o:%.cpp
	$(COMPILE.cxx) $< -o $@

.obj/%.o:%.CPP
	$(COMPILE.cxx) $< -o $@

.obj/%.o:%.c++
	$(COMPILE.cxx) $< -o $@

.obj/%.o:%.cp
	$(COMPILE.cxx) $< -o $@

.obj/%.o:%.cxx
	$(COMPILE.cxx) $< -o $@

