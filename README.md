# LaMake

Generic build & install system for C, C++ and other projects.

License  : GPL (General Public License), version 2+.

Author   : Arend Lammertink <lamare AT gmail DOT com>

Date     : 2016/05/18 (version 0.1)

Description:
------------

If you're a programmer and anything like me, you don't like to spend
your time on writing makefiles, especially not for small/simple
projects. Deep down, you know makefiles are pretty powerful and that
you should probably learn how to make these, but, yeah, the syntax is
awful and you just never got to looking into it. At least, I didn't.

Years ago, at my first real programming job, we had a very nice make
system called PMake. The idea was that the make system assisted you in
keeping your software, a large project, organized. There was a
Makefile in every source directory, in which you pretty much specified
which sources were to go into libraries, which were program sources
and which subsystems your sources were dependent upon. As in: which
libraries do you use? And then you included Pmake, which did the hard
work for you.

With this concept in mind, I made LaMake, intended for not too-big
projects, such as embedded projects for a BeagleBone, where you make
some executables and/or a single library, which you install in /usr or
/usr/local/. Actually, I made this specifically to build relatively
small projects for the Beagle, with a Debian-based Linux OS, such that
one can easily make Debian packages out of your project, which
basically means: supporting "make install" and, preferably, "make
uninstall".

Another basic concept in LaMake is: "use reasonable defaults, but
allow exceptions". That's why a made a lot of use of "?=" assignments.
By default, all variables assigned using ?= are assigned a "reasonable
default", but you can override these defaults by assigning something
else before including a LaMake makefile. This gives you a simple
system to start with, just say which sources are to become programs,
while also givig you the opportunity to fine-tune the system in case
you need it.



GNU make is expected when using these makefiles. Other versions of
make may or may not work.



Usage:
------

Make a file 'Makefile' in the top directory, like:

    SUBDIRS  = src utils foo/bar
    include LaMake/recurse.mk


All of the directories specified in SUBDIRS should have a Makefile
with at least the targets you wish to build/install from the
toplevel.

In the subdirectories (build directories), you make a Makefile like
this:


    PROGRAMS   = pasm.c
    MY_CFLAGS  = D_UNIX_
    include LaMake/build.mk

And that's about it for a simple project. LaMake takes care of
building your project, by looking at what sources are in your
directories.

Make Targets:
------------
The Makefiles provide the following targets, of which test and doc are
optional and have not been implemented yet but at the toplevel:


    $ make [all]                      compile and link
    $ make clean                      clean all files generated by make
    $ make install   [DESTDIR = ...]  install package to   $(prefix)
    $ make uninstall [DESTDIR = ...]  uninstall files from $(prefix)
    $ make test                       build & run tests
    $ make doc                        build documentation

Note: $(prefix) defaults to $(DESTDIR)/usr

Based on:
---------

* [Recursive Makefile Example](http://www.lackof.org/taggart/hacking/make-example/)
* [Autodependencies with GNU make](http://scottmcpeak.com/autodepend/autodepend.html)
* [Using make and writing Makefiles](https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html)
* [Generic Makefile for C/C++ Programs](https://sourceforge.net/projects/gcmakefile/)
* PMake (private source)


# Standard/default directory structure:


     Topdir -----  bin          binaries
             +---  src          source code
               +-  .obj         object, dependencies, etc.
             +---  include      include files
             +---  lib          (shared) libraries
             +---  doc          documentation
             +---  test         Test programs, to be run with make test
             +---  examples     Examples to show how to use the software




