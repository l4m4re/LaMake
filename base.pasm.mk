
# TODO: add intro



#---------------------------------------------------------------------------
# Compilers / linkers
#---------------------------------------------------------------------------
PASM             ?= pasm
COMPILE.pasm     ?= $(PASM) $(MY_CFLAGS.pasm) $(CFLAGS.pasm) \
                    $(addprefix -I,$(INCDIRS)) 
# Use LINK for outputting 'little endian binary output (*.bin)'
LINK.pasm        ?= $(PASM) $(MY_CFLAGS.pasm) -b \
                    $(addprefix -I,$(INCDIRS)) 

#---------------------------------------------------------------------------
#
#
ifneq ($(USE_FREEBASIC),)
# 'FreeBasic array' binary output
 CFLAGS.pasm       ?= -f
else
# default to 'C array' binary output
 CFLAGS.pasm       ?= -c
endif

ifneq ($(DEBUG),)
 CFLAGS.pasm       += -z
endif

#---------------------------------------------------------------------------
# PASM
#---------------------------------------------------------------------------
SRC.objs.pasm     ?= $(ALLSRC.pasm)
#OBJS.pasm         ?= $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, \
#			$(basename $(SRC.objs.pasm))) ))

# Construct targets in BINDIR
ifeq ($(BINDIR),)
  TARGETS.pasm    ?= $(notdir $(basename $(BINSRC.pasm)))
else
  TARGETS.pasm    ?= $(addprefix $(strip $(BINDIR))/, \
		     $(notdir $(addsuffix .bin, \
                     $(basename $(BINSRC.pasm)))))
endif

# Add PASM targets to global targets
OBJS.all         += $(OBJS.pasm)
TARGETS.all      += $(TARGETS.pasm)
