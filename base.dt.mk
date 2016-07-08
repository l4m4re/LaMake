
# TODO: add intro



#---------------------------------------------------------------------------
# Compilers / linkers
#---------------------------------------------------------------------------
DTC            ?= dtc
CFLAGS.dt      ?= -O dtb -b 0 --symbols 
COMPILE.dt     ?= $(DTC) $(MY_CFLAGS.dt) $(CFLAGS.dt) \
                    $(addprefix -i,$(INCDIRS)) 

#---------------------------------------------------------------------------
# dt
#---------------------------------------------------------------------------
#SRC.objs.dt     ?= $(ALLSRC.dt)
#OBJS.dt         ?= $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, \
#			$(basename $(SRC.objs.dt))) ))

VERSION.dt      ?= 00A0
#KEY.dt          ?= bone_capemgr.enable_partno
#UENV.dt          = $(INST_DIR_ROOT)boot/uEnv.txt
#SET_UENV.dt      = $(LAMAKE)tools/set_uenv.py
#RM_SLOTS.dt      = $(LAMAKE)tools/read_slots.py
#SLOTS.dt        ?= $(INST_DIR_ROOT)sys/devices/platform/bone_capemgr/slots

# Construct targets in BINDIR
ifeq ($(BINDIR),)
  TARGETS.dt    ?= $(notdir $(basename $(BINSRC.dt)))
else
  TARGETS.dt    ?= $(addprefix $(strip $(BINDIR))/, \
		     $(notdir $(addsuffix .dtbo, \
                     $(basename $(BINSRC.dt))-$(VERSION.dt) )))
endif

# The different types of install files and where they should go
#  Overlay binaries
INST_FILES_BIN.dt    ?= $(TARGETS.dt)
INST_DIR_BIN.dt      ?= $(INST_DIR_ROOT)lib/firmware
INST_TARGETS_BIN.dt  ?= $(addprefix $(strip $(INST_DIR_BIN.dt))/, \
		        $(notdir $(INST_FILES_BIN.dt)) )
#  Udev rules
INST_FILES_UDEV.dt   ?= $(wildcard *.rules)
INST_DIR_UDEV.dt     ?= $(INST_DIR_ROOT)etc/udev/rules.d
INST_TARGETS_UDEV.dt ?= $(addprefix $(strip $(INST_DIR_UDEV.dt))/, \
		        $(notdir $(INST_FILES_UDEV.dt)) )
# Taken together in standard variables
INST_FILES.dt         = $(INST_FILES_UDEV.dt) $(INST_FILES_BIN.dt)
INST_TARGETS.dt       = $(INST_TARGETS_UDEV.dt) $(INST_TARGETS_BIN.dt)


# Add to global ".all" variables
#OBJS.all            += $(OBJS.dt)
TARGETS.all          += $(TARGETS.dt)
INST_FILES.all       += $(INST_FILES.dt)
INST_TARGETS.all     += $(INST_TARGETS.dt)


