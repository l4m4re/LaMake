
# TODO: add intro



#===========================================================================
# Main variables. All declared with ?= assignments, so they can be
# overriden by any makefile which includes this one. This way, we can
# implement reasonable defaults, yet allow for quite some project
# specific finetuning.
#===========================================================================

#---------------------------------------------------------------------------
# At leat one of these MUST be set by the user: If both PROGRAMS and
# LIBNAME are set, the programs are built from the specified sources and
# a (shared) library will be built with the remaining sources.
#---------------------------------------------------------------------------
#PROGRAMS        = 
LIBNAME         ?= $(CURDIR)
LIBTYPE         ?= static       # default: static
                                # alternative: dylib for .so/.dll/dylib

INSTALLTP       ?= release      # default: release: just the program or lib
                                # alternative: develop: +headers, etc. 

#---------------------------------------------------------------------------
# Directory structure defaults
#---------------------------------------------------------------------------
SRCDIRS         ?= .
INCDIRS         ?= ../include
BINDIR          ?= ../bin
LIBDIR          ?= ../lib
#TESTDIR         ?= ../test
#EXAMPLEDIR      ?= ../examples
#DOCDIR          ?= ../doc

## Note:
##
## OBJDIR       ?= ../obj      
##
## I tried to make this configurable, but I could not get this to work.
## So, we settle for a fixed .obj hidden directory, where the dependency
## files will also reside. This is hard coded in rules (See: obj.mk)
##
## Make sure there are no trailing spaces on the next line:
OBJDIR           = .obj

#---------------------------------------------------------------------------
# Control variables
#---------------------------------------------------------------------------
# Source suffixes
SRCSUFX.c       ?= .c .C
SRCSUFX.cc      ?= .cc .cpp .CPP .c++ .cxx .cp
SRCSUFX.bas     ?= .bas .BAS
SRCSUFX.pasm    ?= .p .P
SRCSUFX.asm     ?= .s .S
SRCSUFX.dts     ?= .dts .DTS
# Headers suffixes
HDRSUFX.cpa     ?= .h .H .hh .hpp .HPP .h++ .hxx .hp  # C, C++, (p)asm
HDRSUFX.bas     ?= .bi .BI                            # Basic
#HDRSUFX.pasm    ?= .hp .HP                            # pasm

# Delete the default suffixes
.SUFFIXES :


# Rules are the core of LaMake. On the basis of a specific part of the
# file name - most often the suffix - LaMake makes decisions on what to
# do with it.  For example, a file with suffix .c can produce a file
# with .o by compiling with the C compiler. Here is a list of suffixes
# used by LaMake:

.SUFFIXES : $(SRCSUFX.c) $(SRCSUFX.cc) $(SRCSUFX.bas) $(SRCSUFX.pasm) \
            $(SRCSUFX.asm) $(SRCSUFX.dts) \
            $(HDRSUFX.cpa) $(HDRSUFX.bas) $(HDRSUFX.pasm)


#===========================================================================
# The dirty details aka implementation.
#===========================================================================

include LaMake/tools.mk

#---------------------------------------------------------------------------
# Sources
#---------------------------------------------------------------------------
# Split PROGRAMS variable (set by the user) into the PROGS for each type
PROGS.c    ?= $(foreach sfx, $(SRCSUFX.c),   $(filter %$(sfx),$(PROGRAMS)))
PROGS.cc   ?= $(foreach sfx, $(SRCSUFX.cc),  $(filter %$(sfx),$(PROGRAMS)))
PROGS.bas  ?= $(foreach sfx, $(SRCSUFX.bas), $(filter %$(sfx),$(PROGRAMS)))
PROGS.asm  ?= $(foreach sfx, $(SRCSUFX.asm), $(filter %$(sfx),$(PROGRAMS)))

# Helper functions
getsrcs          = $(foreach d, $(SRCDIRS), \
			    $(wildcard $(addprefix $(d)/*,$(1))))

getprogswithdir  = $(foreach d, $(SRCDIRS), \
		   $(foreach p, $(1),       \
		   $(wildcard $(addprefix $(d)/,$(p)) )))

# Source types which can produce a program
#
# First set ALLSRC by calling getsrcs, so we get all existing sources of
# a certain type. Then set PROGSRC by looking for PROGS in all SRCDIRS.
# Finally, set SRC by filtering out the PROGSRC from ALLSRC.
ALLSRC.c        ?= $(strip $(call getsrcs,$(SRCSUFX.c)))
PROGSRC.c       ?= $(strip $(call getprogswithdir,$(PROGS.c)))
SRC.c           ?= $(strip $(filter-out $(PROGSRC.c),$(ALLSRC.c)))

ALLSRC.cc       ?= $(strip $(call getsrcs,$(SRCSUFX.cc)))
PROGSRC.cc      ?= $(strip $(call getprogswithdir,$(PROGS.cc)))
SRC.cc          ?= $(strip $(filter-out $(PROGSRC.cc),$(ALLSRC.cc)))

ALLSRC.bas      ?= $(strip $(call getsrcs,$(SRCSUFX.bas)))
PROGSRC.bas     ?= $(strip $(call getprogswithdir,$(PROGS.bas)))
SRC.bas         ?= $(strip $(filter-out $(PROGSRC.bas),$(ALLSRC.bas)))

ALLSRC.asm      ?= $(strip $(call getsrcs,$(SRCSUFX.asm)))
PROGSRC.asm     ?= $(strip $(call getprogswithdir,$(PROGS.asm)))
SRC.asm         ?= $(strip $(filter-out $(PROGSRC.asm),$(ALLSRC.asm)))

# Source types which cannot produce a program
ALLSRC.pasm     ?= $(strip $(call getsrcs, $(SRCSUFX.pasm)))
ALLSRC.dts      ?= $(strip $(call getsrcs, $(SRCSUFX.dts)))

# Taking things together
PROGS.all       ?= $(strip $(PROGS.c) $(PROGS.cc) $(PROGS.bas) $(PROGS.asm) )
PROGSRC.all     ?= $(strip$(PROGSRC.c) $(PROGSRC.cc) $(PROGSRC.bas) \
                   $(PROGSRC.asm) )
ALLSRC.all      ?= $(strip $(ALLSRC.c) $(ALLSRC.cc) $(ALLSRC.bas) \
                   $(ALLSRC.asm) $(ALLSRC.pasm) $(ALLSRC.dts) )

#---------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------
DEPS.all        ?=
TARGETS.all     ?=

#---------------------------------------------------------------------------
# Include base flags and targets by language
#---------------------------------------------------------------------------
ALLSRC.cxx      := $(strip $(ALLSRC.c) $(ALLSRC.cc))
ifneq ($(ALLSRC.cxx),)
  include LaMake/base.cxx.mk
endif

ifneq ($(ALLSRC.bas),)
  include LaMake/base.bas.mk
endif


#---------------------------------------------------------------------------
# Rules
#---------------------------------------------------------------------------
.PHONY: all objs deps clean show install uninstall test doc directories

all: directories $(OBJS.all) $(TARGETS.all)

# Rule for making sure .obj dir exists
directories: $(OBJDIR) $(LIBDIR)

$(OBJDIR):
	$(MKDIR_P) $(OBJDIR)

$(LIBDIR):
	$(MKDIR_P) $(LIBDIR)


#---------------------------------------------------------------------------
# Language specific rules
#---------------------------------------------------------------------------
ifneq ($(ALLSRC.cxx),)
 include LaMake/rules.cxx.mk
endif

ifneq ($(ALLSRC.bas),)
 include LaMake/rules.bas.mk
endif

clean:
	$(RM) $(OBJS) $(DEPS) $(TARGETS.all) .obj/*.o *.o *.d *~ \
        $(INCDIR)/*~ $(LOG)


include LaMake/show.mk

#####  NOTES ####

# ronn can be used to convert .md to man pages:
# https://spin.atomicobject.com/2015/05/06/man-pages-in-markdown-ronn/
#
# arend@beaglebone:~/src/libpruio-0.2$ apt-cache search ronn
# ruby-ronn - Builds manuals from Markdown
#
# For html output, there is:
# http://daringfireball.net/projects/markdown/
#
# apt-cache search markdow  gives a whole load of available packages
# including ronn


#ifeq ($(PROGRAM),)
#  CUR_PATH_NAMES = $(subst /,$(SPACE),$(subst $(SPACE),_,$(CURDIR)))
#  PROGRAM = $(word $(words $(CUR_PATH_NAMES)),$(CUR_PATH_NAMES))
#  ifeq ($(PROGRAM),)
#    PROGRAM = a.out
#  endif
#endif


#ifneq ("$(wildcard $(PATH_TO_FILE))","")
#FILE_EXISTS = 1
#else
#FILE_EXISTS = 0
#endif
