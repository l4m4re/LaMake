
# TODO: add intro

#---------------------------------------------------------------------------
# Main variable. 
#
# Specifies which directories contain a Makefile, which should be called
# by any of the above targets you wish to support from the toplevel.
#
# Default is to recurse into the standard build directories: src, doc
# and test.
# 
#---------------------------------------------------------------------------
SUBDIRS ?= $(wildcard src doc test)

#---------------------------------------------------------------------------
# Variables to pass down recursively.
#---------------------------------------------------------------------------
#
# https://www.gnu.org/software/automake/manual/html_node/DESTDIR.html
#
# "The DESTDIR variable can be used to perform a staged installation.
# The package should be configured as if it was going to be installed in
# its final location (e.g., --prefix /usr), but when running make
# install, the DESTDIR should be set to the absolute name of a directory
# into which the installation will be diverted. From this directory it
# is easy to review which files are being installed where, and finally
# copy them to their final location by some means."
#
# For building debian packages, add the line:
#  export PREFIX:=/usr
# to the "rules" file in your debian directory. 
PREFIX                    ?= /usr/local

export INST_DIR_ROOT      := $(DESTDIR)/
export INST_DIR_USR       := $(DESTDIR)/$(PREFIX)
ifeq ($(PREFIX),/usr/local)
 export INST_DIR_FIRMWARE := $(DESTDIR)/usr/local/lib/firmware
else
 export INST_DIR_FIRMWARE := $(DESTDIR)/lib/firmware
endif
export INST_DIR_BIN       := $(INST_DIR_USR)/bin
export INST_DIR_INC       := $(INST_DIR_USR)/include
export INST_DIR_LIB       := $(INST_DIR_USR)/lib

#---------------------------------------------------------------------------
# The dirty details aka implementation.
#---------------------------------------------------------------------------

# the sets of directories to call recursively
BUILDDIRS     = $(SUBDIRS:%=build-%)
INSTALLDIRS   = $(SUBDIRS:%=install-%)
UNINSTALLDIRS = $(SUBDIRS:%=uninstall-%)
CLEANDIRS     = $(SUBDIRS:%=clean-%)
TESTDIRS      = $(SUBDIRS:%=test-%)
DOCDIRS       = $(SUBDIRS:%=doc-%)
SHOWDIRS      = $(SUBDIRS:%=show-%)

# and the rules.
all: $(BUILDDIRS)
$(SUBDIRS): $(BUILDDIRS)
$(BUILDDIRS):
	$(MAKE) -C $(@:build-%=%)

install: all $(INSTALLDIRS)
$(INSTALLDIRS):
	$(MAKE) -C $(@:install-%=%) install

uninstall: $(UNINSTALLDIRS)
$(UNINSTALLDIRS):
	$(MAKE) -C $(@:uninstall-%=%) uninstall

clean: $(CLEANDIRS)
$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean

test: $(TESTDIRS) all
$(TESTDIRS): 
	$(MAKE) -C $(@:test-%=%) test

doc: $(DOCDIRS)
$(DOCDIRS): 
	$(MAKE) -C $(@:doc-%=%) doc

show: $(SHOWDIRS)
$(SHOWDIRS): 
	$(MAKE) -C $(@:show-%=%) show

.PHONY: subdirs $(SUBDIRS)
.PHONY: subdirs $(BUILDDIRS)
.PHONY: subdirs $(INSTALLDIRS)
.PHONY: subdirs $(TESTDIRS)
.PHONY: subdirs $(CLEANDIRS)
.PHONY: subdirs $(DOCDIRS)
.PHONY: subdirs $(SHOWDIRS)
.PHONY: all install uninstall clean test doc show
#===========================================================================
