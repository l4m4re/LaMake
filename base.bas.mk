
# TODO: add intro



#---------------------------------------------------------------------------
# Compilers / linkers
#---------------------------------------------------------------------------
BAS             ?= fbc
COMPILE.bas     ?= $(BAS) $(MY_CFLAGS.bas) $(CFLAGS.bas) \
                    $(addprefix -i ,$(INCDIRS)) -c
LINK.bas        ?= $(BAS) $(MY_CFLAGS.bas) $(CFLAGS.bas) $(LDFLAGS.bas) \
                    $(addprefix -i ,$(INCDIRS)) 

#---------------------------------------------------------------------------
#
#  -g    adds debugging information to the executable file
#  -Wall turns on most, but not all, compiler warnings
#
CFLAGS.bas        ?= -gen gcc -w all
ifneq ($(DEBUG),)
 CFLAGS.bas       += -g
endif

LDFLAGS.bas     ?= -p $(LIBDIR) $(MY_LDFLAGS.bas)

#---------------------------------------------------------------------------
# BAS
#---------------------------------------------------------------------------
SRC.objs.bas     ?= $(ALLSRC.bas)
OBJS.bas         ?= $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, \
			$(basename $(SRC.objs.bas))) ))

# Construct targets in BINDIR
ifeq ($(BINDIR),)
  TARGETS.bas    ?= $(notdir $(basename $(PROGSRC.bas)))
else
  TARGETS.bas    ?= $(addprefix $(strip $(BINDIR))/, \
		    $(notdir $(basename $(PROGSRC.bas))))
endif

# Add bas targets to global targets
OBJS.all         += $(OBJS.bas)
TARGETS.all      += $(TARGETS.bas)

## Some options from fbc man page:
# http://www.freebasic.net/wiki/wikka.php?wakka=CatPgCompOpt
#
# -a file       Treat file as .o/.a input file
# -b file       Treat file as .bas input file
# -c            Compile only, do not link
# -C            Preserve temporary .o files
# -dylib        Create a Win32 DLL or Linux/*BSD shared library
# -export       Export symbols for dynamic linkage
# -g            Add debug info
# -gen gas|gcc  Select code generation backend
# -i path       Add an include file search path
# -l name       Link in a library
# -m name       Set main module (default if not -c: first input .bas)
# -o file       Set .o file name for corresponding input .bas
# -p path       Add a library search path
# -prefix path  Set the compiler prefix path
# -r            Write out .asm (-gen gas) or .c (-gen gcc) only
# -rr           Write out the final .asm only
# -R            Preserve the temporary .asm/.c file
# -RR           Preserve the final .asm file
# -Wa a,b,c     Pass options to GAS
# -Wc a,b,c     Pass options to GCC (with -gen gcc)
# -Wl a,b,c     Pass options to LD
# -x file       Set output executable/library file name

