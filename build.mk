
# TODO: add intro



#===========================================================================
# Main variables. All declared with ?= assignments, so they can be
# overriden by any makefile which includes this one. This way, we can
# implement reasonable defaults, yet allow for quite some project
# specific finetuning.
#===========================================================================

#---------------------------------------------------------------------------
# At leat one of these MUST be set by the user: If both BINARIES and
# LIBNAME are set, the BINARIES are built from the specified sources and
# a (shared) library will be built with the remaining sources.
#---------------------------------------------------------------------------
#BINARIES        = 
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

# Installation directories. Should be set&passed down from recurse.mk,
# but it's handy for testing installation of a subdir seperately.
INST_DIR_ROOT     ?= $(DESTDIR)/
INST_DIR_USR      ?= $(DESTDIR)/usr/local
INST_DIR_FIRMWARE ?= $(DESTDIR)/usr/local/lib/firmware
INST_DIR_BIN      ?= $(INST_DIR_USR)/bin
INST_DIR_INC      ?= $(INST_DIR_USR)/include
INST_DIR_LIB      ?= $(INST_DIR_USR)/lib

#---------------------------------------------------------------------------
# Control variables
#---------------------------------------------------------------------------
# Source suffixes
SRCSUFX.c       ?= .c .C
SRCSUFX.cc      ?= .cc .cpp .CPP .c++ .cxx .cp
SRCSUFX.bas     ?= .bas .BAS
SRCSUFX.pasm    ?= .p .P
SRCSUFX.asm     ?= .s .S
SRCSUFX.dt      ?= .dts .DTS
# Headers suffixes
HDRSUFX.cpa     ?= .h .H .hh .hpp .HPP .h++ .hxx .hp  # C, C++, (p)asm
HDRSUFX.bas     ?= .bi .BI                            # Basic
#HDRSUFX.dt     ?= .dtsi                              # Linux Device Tree
#HDRSUFX.pasm   ?= .hp .HP                            # pasm

# Delete the default suffixes
.SUFFIXES :


# Rules are the core of LaMake. On the basis of a specific part of the
# file name - most often the suffix - LaMake makes decisions on what to
# do with it.  For example, a file with suffix .c can produce a file
# with .o by compiling with the C compiler. Here is a list of suffixes
# used by LaMake:

.SUFFIXES : $(SRCSUFX.c) $(SRCSUFX.cc) $(SRCSUFX.bas) $(SRCSUFX.pasm) \
            $(SRCSUFX.asm) $(SRCSUFX.dt) \
            $(HDRSUFX.cpa) $(HDRSUFX.bas) $(HDRSUFX.pasm)


#===========================================================================
# The dirty details aka implementation.
#===========================================================================

include LaMake/tools.mk

#---------------------------------------------------------------------------
# Sources
#---------------------------------------------------------------------------
# Split BINARIES variable (set by the user) into the BINS for each type
BINS.c    ?= $(strip $(foreach sfx, $(SRCSUFX.c),    $(filter %$(sfx),$(BINARIES))))
BINS.cc   ?= $(strip $(foreach sfx, $(SRCSUFX.cc),   $(filter %$(sfx),$(BINARIES))))
BINS.dt   ?= $(strip $(foreach sfx, $(SRCSUFX.dt),   $(filter %$(sfx),$(BINARIES))))
BINS.bas  ?= $(strip $(foreach sfx, $(SRCSUFX.bas),  $(filter %$(sfx),$(BINARIES))))
BINS.asm  ?= $(strip $(foreach sfx, $(SRCSUFX.asm),  $(filter %$(sfx),$(BINARIES))))
BINS.pasm ?= $(strip $(foreach sfx, $(SRCSUFX.pasm), $(filter %$(sfx),$(BINARIES))))

# Helper functions
getsrcs          = $(foreach d, $(SRCDIRS), \
			    $(wildcard $(addprefix $(d)/*,$(1))))

getprogswithdir  = $(foreach d, $(SRCDIRS), \
		   $(foreach p, $(1),       \
		   $(wildcard $(addprefix $(d)/,$(p)) )))

# Used for finding include files for installation in a/o base.bas.mk
getincs          = $(foreach d, $(INCDIRS), \
		   $(foreach s, $(1),       \
		   $(wildcard $(addprefix $(d)/*,$(s)) )))

# Source types which can produce a program
#
# First set ALLSRC by calling getsrcs, so we get all existing sources of
# a certain type. Then set BINSRC by looking for BINS in all SRCDIRS.
# Finally, set SRC by filtering out the BINSRC from ALLSRC.
ALLSRC.c        ?= $(strip $(call getsrcs,$(SRCSUFX.c)))
BINSRC.c        ?= $(strip $(call getprogswithdir,$(BINS.c)))
SRC.c           ?= $(strip $(filter-out $(BINSRC.c),$(ALLSRC.c)))

ALLSRC.cc       ?= $(strip $(call getsrcs,$(SRCSUFX.cc)))
BINSRC.cc       ?= $(strip $(call getprogswithdir,$(BINS.cc)))
SRC.cc          ?= $(strip $(filter-out $(BINSRC.cc),$(ALLSRC.cc)))

ALLSRC.bas      ?= $(strip $(call getsrcs,$(SRCSUFX.bas)))
BINSRC.bas      ?= $(strip $(call getprogswithdir,$(BINS.bas)))
SRC.bas         ?= $(strip $(filter-out $(BINSRC.bas),$(ALLSRC.bas)))

ALLSRC.asm      ?= $(strip $(call getsrcs,$(SRCSUFX.asm)))
BINSRC.asm      ?= $(strip $(call getprogswithdir,$(BINS.asm)))
SRC.asm         ?= $(strip $(filter-out $(BINSRC.asm),$(ALLSRC.asm)))

ALLSRC.pasm     ?= $(strip $(call getsrcs, $(SRCSUFX.pasm)))
BINSRC.pasm     ?= $(strip $(call getprogswithdir,$(BINS.pasm)))
SRC.pasm        ?= $(strip $(filter-out $(BINSRC.pasm),$(ALLSRC.pasm)))

# Linux Device Tree
ALLSRC.dt       ?= $(strip $(call getsrcs, $(SRCSUFX.dt)))
BINSRC.dt       ?= $(strip $(call getprogswithdir,$(BINS.dt)))
SRC.dt          ?= $(strip $(filter-out $(BINSRC.dt),$(ALLSRC.dt)))


# Source types which cannot produce a program
# None at this point


# Taking things together
BINS.all       ?= $(strip $(BINS.c) $(BINS.cc) $(BINS.bas) \
                   $(BINS.asm) $(BINS.pasm) $(BINS.dt)  )
BINSRC.all     ?= $(strip$(BINSRC.c) $(BINSRC.cc) $(BINSRC.bas) \
                   $(BINSRC.asm) $(BINSRC.pasm) $(BINS.dt) )
ALLSRC.all      ?= $(strip $(ALLSRC.c) $(ALLSRC.cc) $(ALLSRC.bas) \
                   $(ALLSRC.asm) $(ALLSRC.pasm) $(ALLSRC.dt) )

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

ifneq ($(ALLSRC.pasm),)
  include LaMake/base.pasm.mk
endif

ifneq ($(ALLSRC.dt),)
  include LaMake/base.dt.mk
endif

#---------------------------------------------------------------------------
# Rules
#---------------------------------------------------------------------------
.PHONY: all objs deps clean show install uninstall test doc directories

all: init directories $(OBJS.all) $(TARGETS.all) $(MY_TARGETS)

# Rule for making sure directories exists
directories: objdir bindir libdir 

.PHONY: objdir bindir libdir

objdir:
	@$(MKDIR_P) $(OBJDIR)

bindir:
	@$(MKDIR_P) $(BINDIR)

libdir:
	@$(MKDIR_P) $(LIBDIR)

init:
	@-$(RM) $(LOG)

#---------------------------------------------------------------------------
# Language specific rules
#---------------------------------------------------------------------------
ifneq ($(ALLSRC.cxx),)
 include LaMake/rules.cxx.mk
endif

ifneq ($(ALLSRC.bas),)
 include LaMake/rules.bas.mk
endif

ifneq ($(ALLSRC.pasm),)
 include LaMake/rules.pasm.mk
endif

ifneq ($(ALLSRC.dt),)
  include LaMake/rules.dt.mk
endif

clean:
	$(RM) $(OBJS) $(DEPS) $(TARGETS.all) .obj/*.o *.o *.d *~ \
        $(INCDIR)/*~ $(LOG) $(MY_CLEAN)

install: install.bas install.dt

uninstall: 
	@for filenm in $(INST_TARGETS.all) ; \
	do \
	    if [ -e $$filenm ] ; then         \
		    rm -fv $$filenm ; \
	    fi \
	done



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
