# build #

Boilerplate build system for c/c++ projects built with the GNU Compiler
Collection (GCC).

The idea behind the project is to provide a simple generic mechanism for
building c/c++ projects while abstracting away more advanced elements. These
includes auto-dependency generation, common compiling/linking flags and OS
architecture abstraction.

It can be used as a base for many small projects as well as providing a
framework for large projects with many libs and dependencies.

This project has been heavily influenced by the Android build system. It has
however been rebuilt, stripping out unnecessary elements and simplifying things
for smaller c/c++ projects

# Setting up #

1. `$ mkdir <project root>` *// Root for all your projects*
2. `$ cd <project root>`
3. `$ git clone https://github.com/DalaiLlama/build.git` *// Get this project*
4. `$ cp build/Makefile.template Makefile`
5. Update the Makefile with the project name (This is used to find the
   *<project>.mk* files later)
6. `mkdir <new project>`
7. Check [the examples](example/) for sample code on how to build
   [executables](example/binSample/executables/),
   [libraries](example/libSample/),
   [static libraries](example/libStaticSample/) and
   [tests](example/binSample/tests/).


# Description #
## TODO ##
* Tidy this area up
* Recommended folder structure

Walk through what happens when you 'make'

* Setting up system:
    + Choosing arch etc.
    + Find all makefiles if needed
* Build selected targets:
    + Compiling: e.g. c++ => o
    + Dependency list
    + Linking: e.g. o => exe
    + Stripping
* What binaries are built and where they go.

Notable points:
* Knowing when files have been modified
* Dependency list

# Issues #
* When building within cyginw, use the mingw binaries. Problems with
[statically linking against cygwin1.dll](http://stackoverflow.com/questions/340696/can-you-statically-compile-a-cygwin-application).
Need to check the `-mno-cygwin` flag.


# TODO #
* Linux handling
* Tidy up and document compilation and linking flags
* Sort out copyright information. (Rewritten from android make system.)
* Get the lib examples working
* Get the test example working (Use gtest? - How to incorporate? External folder like android?)
* Strip out all the redundant stuff
* Not to get distracted on this and work on other projects!
