
# TODO: add intro


#===========================================================================
# Configuration of the tools used.
#===========================================================================
#---------------------------------------------------------------------------
# Basic Tools & Definitions
#---------------------------------------------------------------------------
# 
# The first things needed are some variable definitions:
#
# `HOSTNAME' is computed for user display. 
#
# `TMPFILEBASE' is a name for temporary files in LaMake. 
#
# `LOG' is the name of the log file. It defaults to `ls$(HDIR)'. If you
# want  to overrule this name, define LOG before including LaMake. 
#
# `OUT' is the variable used to actually put output in the log file. It
# depends on `LOG'. If you set `OUTSTDOUT := yes' before including
# LaMake, LaMake will not make a log file. 
#
# `TEE' is like `OUT' but simultanously puts output on stdout/stderr           
SHELL           ?= /bin/sh
INSTALL         ?= /usr/bin/install
INSTALL_PROGRAM ?= $(INSTALL)
INSTALL_DATA    ?= $(INSTALL) -m 644
RM              ?= rm -f
RMDIR           ?= rm -rf
MKDIR_P         ?= mkdir -p
MV              ?= mv -f                                                       
CP              ?= cp -p                                                       
LN              ?= ln -s                                                       
                                                                               
TMPFILEBASE     ?= _tmp_lamake_
LOG             ?= log.$(HOSTNAME)
                                                                               
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


#---------------------------------------------------------------------------
# Compilers / linkers
#---------------------------------------------------------------------------
MY_CC           ?= gcc
CC               = $(MY_CC)      # CC  is set to cc  by default in gmake
MY_CXX          ?= g++
CXX              = $(MY_CXX)     # CXX is set to g++ by default in gmake
PASM            ?= pasm
BAS             ?= fbc


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

