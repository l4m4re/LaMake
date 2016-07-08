
# TODO: add intro


#---------------------------------------------------------------------------
# Compilers / linkers
#---------------------------------------------------------------------------
MY_CC           ?= gcc
CC               = $(MY_CC)      # CC  is set to cc  by default in gmake
MY_CXX          ?= g++
CXX              = $(MY_CXX)     # CXX is set to g++ by default in gmake


#     https://gcc.gnu.org/onlinedocs/gcc/Preprocessor-Options.html
#
# -M  Instead of outputting the result of preprocessing, output a rule
#     suitable for make describing the dependencies of the main source file.
#
# -MM Like -M but do not mention header files that are found in system
#     header directories, nor header files that are included, directly or
#     indirectly, from such a header.   
#
# -MP This option instructs CPP to add a phony target for each
#     dependency other than the main file, causing each to depend on
#     nothing. These dummy rules work around errors make gives if you remove
#     header files without updating the Makefile to match. 
DEP_OPT     ?= $(shell if `$(CC) --version | grep -i "gcc" >/dev/null`; then \
                  echo "-MM -MP"; else echo "-M"; fi )
DEPEND      ?= $(CC)  $(DEP_OPT)  $(MY_CFLAGS) $(CFLAGS)
DEPEND.d    ?= $(subst -g ,,$(DEPEND))
COMPILE.c   ?= $(CC)  $(MY_CFLAGS) $(CFLAGS.c)  -c
COMPILE.cxx ?= $(CXX) $(MY_CFLAGS) $(CFLAGS.cc) -c
LINK.c      ?= $(CC)  $(MY_CFLAGS.c)  $(CFLAGS.c)  $(LDFLAGS.c)
LINK.cc     ?= $(CXX) $(MY_CFLAGS.cc) $(CFLAGS.cc) $(LDFLAGS.cc)


#---------------------------------------------------------------------------
#
#  -g    adds debugging information to the executable file
#  -Wall turns on most, but not all, compiler warnings
#
CFLAGS.c        ?= -Wall
CFLAGS.cc       ?= -Wall
ifneq ($(DEBUG),)
 CFLAGS.c       += -g
 CFLAGS.cc      += -g
endif

LDFLAGS.c       ?= -L$(LIBDIR) $(MY_LDFLAGS.c)
LDFLAGS.cc      ?= -L$(LIBDIR) $(MY_LDFLAGS.cc)

SRC.objs.c      ?= $(ALLSRC.c) 
OBJS.c          ?= $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, \
			$(basename $(SRC.objs.c))) ))
DEPS.c          ?= $(OBJS.c:.o=.d)

SRC.objs.cc     ?= $(AllSRC.cc)
OBJS.cc         ?= $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, \
			$(basename $(SRC.objs.cc))) ))
DEPS.cc         ?= $(OBJS.cc:.o=.d)


OBJS.all        += $(OBJS.c) $(OBJS.cc)

# Construct targets in BINDIR
ifeq ($(BINDIR),)
  TARGETS.c     ?= $(notdir $(basename $(BINSRC.c)))
  TARGETS.cc    ?= $(notdir $(basename $(BINSRC.cc)))
else
  TARGETS.c     ?= $(addprefix $(strip $(BINDIR))/, \
		    $(notdir $(basename $(BINSRC.c))))
  TARGETS.cc    ?= $(addprefix $(strip $(BINDIR))/, \
		    $(notdir $(basename $(BINSRC.cc))))
endif
