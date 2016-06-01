#---------------------------------------------------------------------------
# C/C++
#---------------------------------------------------------------------------

# Rules for generating the executables.
#-------------------------------------
$(TARGETS.c):$(OBJS.c) $(DEPS.c)
	$(LINK.c)   $(OBJS.c) $(MY_LIBS) -o $@

$(TARGETS.cc):$(OBJS.cc) $(OBJS.c) $(DEPS.cc) $(DEPS.c)
	$(LINK.cc) $(OBJS.cc) $(OBJS.c) $(MY_LIBS) -o $@

.PHONY: objs.c objs.cc

objs.c: $(OBJS.c)
objs.cc: $(OBJS.cc)

ifndef NODEP
  ifneq ($(DEPS),)
    ifneq ("$(wildcard $(OBJDIR))","") # IF OBJDIR directory exists THEN
      -include $(ALLDEPS)              # include existing dependencies
    endif
  endif
endif

include LaMake/objs.cxx.mk

