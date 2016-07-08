
# TODO: add intro


#===========================================================================
# Configuration of the tools used.
#===========================================================================
#---------------------------------------------------------------------------
# Basic Tools & Definitions
#---------------------------------------------------------------------------
# 
# The first things needed are some variable definitions.
#

# Directory where LaMake is to be found
LAMAKE          := $(dir $(lastword $(MAKEFILE_LIST)))

SHELL           ?= /bin/sh
INSTALL         ?= /usr/bin/install
INSTALL_PROGRAM ?= $(INSTALL)
INSTALL_DATA    ?= $(INSTALL) -m 644
RANLIB          ?= ranlib
RM              ?= rm -f
RMDIR           ?= rm -rf
MKDIR_P         ?= mkdir -p
MV              ?= mv -f                                                       
CP              ?= cp -p                                                       
LN              ?= ln -s                                                       
  
# `HOSTNAME' is computed for user display. 
#
# `TMPFILEBASE' is a name for temporary files in LaMake. 
#
# `LOG' is the name of the log file. It defaults to `log.$(HOSTNAME)'.
# If you want  to overrule this name, define LOG before including
# LaMake. 
#
# `OUT' is the variable used to actually put output in the log file. It
# depends on `LOG'. If you set `OUTSTDOUT := yes' before including
# LaMake, LaMake will not make a log file. 
#
# `TEE' is like `OUT' but simultanously puts output on stdout/stderr           
TMPFILEBASE     ?= _tmp_lamake_
LOG             ?= log.$(HOSTNAME)
TMPPREFIX       ?= /tmp/
                                                                               
HOSTNAME        := $(shell uname -n)
CWD             := $(strip $(shell pwd))
CURDIR          := $(notdir $(CWD))
DATE            := $(wordlist 2,4,$(shell date))

EMPTY           =
SPACE           = $(EMPTY) $(EMPTY)

                                                                               
ifeq ($(OUTSTDOUT),yes)                                                        
    OUT         := $(EMPTY)
    TEE         := $(EMPTY)
else                                                                           
    OUT         := 1>>$(LOG) 2>&1
    TEE         := | tee -a $(LOG)
endif                                                                          
                                                                               
CLEAN           := *.o a.out core *\~ log.* \
		   *.ppc *.lint *.ppi $(TMPFILEBASE).* 

