
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
COMPILE.c   ?= $(CC)  $(MY_CFLAGS) $(CFLAGS)   -c
COMPILE.cxx ?= $(CXX) $(MY_CFLAGS) $(CXXFLAGS) -c
LINK.c      ?= $(CC)  $(MY_CFLAGS) $(CFLAGS)   $(LDFLAGS)
LINK.cxx    ?= $(CXX) $(MY_CFLAGS) $(CXXFLAGS) $(LDFLAGS)


#---------------------------------------------------------------------------
#
#  -g    adds debugging information to the executable file
#  -Wall turns on most, but not all, compiler warnings
#
CFLAGS          ?= -Wall
CXXFLAGS        ?= -Wall
ifneq ($(DEBUG),)
 CFLAGS         += -g
 CXXFLAGS       += -g
endif

LIBDIRMINL      := -L$(LIBDIR)  #TODO : for each LIBDIR
LDFLAGS         = $(LIBDIRMINL) $(OWNLDFLAGS)

SRC.objs.c      ?= $(ALLSRC.c) $(AllSRC.c)
OBJS.c          ?= $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, \
			$(basename $(SRC.objs.c))) ))
DEPS.c          ?= $(OBJS.c:.o=.d)

SRC.objs.cc     ?= $(AllSRC.cc)
OBJS.cc         ?= $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, \
			$(basename $(SRC.objs.cc))) ))
DEPS.cc         ?= $(OBJS.cc:.o=.d)

# Construct targets in BINDIR
ifeq ($(BINDIR),)
  TARGETS.c     ?= $(notdir $(basename $(PROGSRC.c)))
  TARGETS.cc    ?= $(notdir $(basename $(PROGSRC.cc)))
else
  TARGETS.c     ?= $(addprefix $(strip $(BINDIR))/, \
		    $(notdir $(basename $(PROGSRC.c))))
  TARGETS.cc    ?= $(addprefix $(strip $(BINDIR))/, \
		    $(notdir $(basename $(PROGSRC.cc))))
endif
