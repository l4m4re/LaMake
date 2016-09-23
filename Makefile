#
# Just a minimal Makefile for now to install the most basic components
#
# Currently installs the assembler and the app loader library
#
PREFIX?=/usr/local

TARGETDIR?=$(DESTDIR)$(PREFIX)/include/LaMake
TOOLDIR?=$(TARGETDIR)/tools


all: show.mk

show.mk :
	python ./mkshow.py > show.mk

clean: 
	rm -f show.mk


install:
	install -m 0755 -d $(TARGETDIR)
	install -m 0755 -d $(TOOLDIR)
	install -m 0755 *.py $(TARGETDIR) 
	install -m 0755 tools/*.py $(TOOLDIR) 
	install -m 0644 *.mk $(TARGETDIR) 
