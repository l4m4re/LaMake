
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
#LIBNAME         = mylib
LIBTYPE         ?= dylib        # default: dylib for dynamically linked .so
                                # alternative: static 

INSTALLTP       ?= release      # default: release: just the program or lib
                                # alternative: develop: +headers, etc. 

#---------------------------------------------------------------------------
# Directory structure defaults
#---------------------------------------------------------------------------
SRCDIRS         ?= .
INCDIRS         ?= ../include
BINDIR          ?= ../bin
LIBDIR          ?= ../lib
TESTDIR         ?= ../test
DOCDIR          ?= ../doc

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
# Delete the default suffixes
.SUFFIXES:


include LaMake/tools.mk

#---------------------------------------------------------------------------
# Flags 
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

#===========================================================================
# The dirty details aka implementation.
#===========================================================================

#---------------------------------------------------------------------------
# Get source files 
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
ALLSRC.c        ?= $(call getsrcs,$(SRCSUFX.c)) 
PROGSRC.c       ?= $(call getprogswithdir,$(PROGS.c) )
SRC.c           ?= $(filter-out $(PROGSRC.c),$(ALLSRC.c) )

ALLSRC.cc       ?= $(call getsrcs,$(SRCSUFX.cc)) 
PROGSRC.cc      ?= $(call getprogswithdir,$(PROGS.cc) )
SRC.cc          ?= $(filter-out $(PROGSRC.cc),$(ALLSRC.cc) )

# Source types which cannot produce a program
SRC.pasm        ?= $(call getsrcs, $(SRCSUFX.pasm))
SRC.dts         ?= $(call getsrcs, $(SRCSUFX.dts))

# Taking things together
PROGS.all       ?= $(PROGS.c) $(PROGS.cc) $(PROGS.bas) $(PROGS.asm) 
PROGSRC.all     ?= $(PROGSRC.c) $(PROGSRC.cc) $(PROGSRC.bas) $(PROGSRC.asm) 

#---------------------------------------------------------------------------
# C/C++
#---------------------------------------------------------------------------
SRC.objs   ?= $(ALLSRC.c) $(AllSRC.cc)
OBJS       ?= $(addprefix $(OBJDIR)/, $(notdir $(addsuffix .o, \
			$(basename $(SRC.objs))) ))
DEPS       ?= $(OBJS:.o=.d)

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

TARGETS.all     ?= $(TARGETS.c) $(TARGETS.cc) $(TARGETS.bas) $(TARGETS.asm) 





.PHONY: all objs deps clean show install uninstall test doc directories

all: directories $(TARGETS.all)

directories: $(OBJDIR)

$(OBJDIR):
	$(MKDIR_P) $(OBJDIR)


# Rules for creating dependency files (.d).
# Rules for generating object files (.o).
include LaMake/objs.mk

# Rules for generating the executables.
#-------------------------------------
$(TARGETS.c):$(OBJS) $(DEPS)
	$(LINK.c)   $(OBJS) $(MY_LIBS) -o $@

$(TARGETS.cc):$(OBJS) $(DEPS)
	$(LINK.cxx) $(OBJS) $(MY_LIBS) -o $@

ifndef NODEP
  ifneq ($(DEPS),)
    ifneq ("$(wildcard $(OBJDIR))","") # IF OBJDIR directory exists THEN
      -include $(DEPS)                 # include existing dependencies
    endif
  endif
endif

clean:
	$(RM) $(OBJS) $(DEPS) $(TARGETS.all) *.o *.d *~ $(INCDIR)/*~ 




# Show variables (for debug use only.)
show:
	@echo '++ PROGRAMS     :' $(PROGRAMS)
	@echo '++ SRCDIRS      :' $(SRCDIRS)
	@echo '+++ C     ++++++'
	@echo '++ PROGS.c      :' $(PROGS.c)
	@echo '++ ALLSRC.c     :' $(ALLSRC.c)
	@echo '++ PROGSRC.c    :' $(PROGSRC.c)
	@echo '++ SRC.c        :' $(SRC.c)
	@echo '++ TARGETS.c    :' $(TARGETS.c)
	@echo '+++ C++   ++++++'
	@echo '++ PROGS.cc     :' $(PROGS.cc)
	@echo '++ ALLSRC.cc    :' $(ALLSRC.cc)
	@echo '++ PROGSRC.cc   :' $(PROGSRC.cc)
	@echo '++ SRC.cc       :' $(SRC.cc)
	@echo '++ TARGETS.cc   :' $(TARGETS.cc)
	@echo '+++ BAS   ++++++'
	@echo '++ PROGS.bas    :' $(PROGS.bas)
	@echo '++ ALLSRC.bas   :' $(ALLSRC.bas)
	@echo '++ PROGSRC.bas  :' $(PROGSRC.bas)
	@echo '++ SRC.bas      :' $(SRC.bas)
	@echo '+++ ASM   ++++++'
	@echo '++ PROGS.asm    :' $(PROGS.asm)
	@echo '++ ALLSRC.asm   :' $(ALLSRC.asm)
	@echo '++ PROGSRC.asm  :' $(PROGSRC.asm)
	@echo '++ SRC.asm      :' $(SRC.asm)
	@echo '+++ other ++++++'
	@echo '++ SRC.pasm     :' $(SRC.pasm)
	@echo '++ SRC.dts      :' $(SRC.dts)
	@echo '+++ targets ++++'
	@echo '++ PROGS.all    :' $(PROGS.all)
	@echo '++ PROGSRC.all  :' $(PROGSRC.all)
	@echo '++ TARGETS.all  :' $(TARGETS.all)
	@echo '++ SRC.obj      :' $(SRC.obj)
	@echo '++ OBJS         :' $(OBJS)
	@echo '++ DEPS         :' $(DEPS)
	@echo '+++ Tools ++++++'
	@echo '++ CC           :' $(CC)
	@echo '++ CXX          :' $(CXX)
	@echo '++ PASM         :' $(PASM)
	@echo '++ BAS          :' $(BAS)
	@echo '++ DEP_OPT      :' $(DEP_OPT)
	@echo '++ DEPEND       :' $(DEPEND)
	@echo '++ DEPEND.d     :' $(DEPEND.d)
	@echo '++ COMPILE.c    :' $(COMPILE.c)
	@echo '++ COMPILE.cxx  :' $(COMPILE.cxx)
	@echo '++ LINK.c       :' $(LINK.c)
	@echo '++ LINK.cxx     :' $(LINK.cxx)
 
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
