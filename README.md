## Marvell Semiconductor port of flang based on LLVM 9.0.0.
## Includes LLVM, flang, clang, Polly, compiler-rt, OpenMP, lld, plus a large number of Marvell internal patches.
==============================================================================================

## Building Flang:

1. Create a directory where you will clone this Github repo:

```
%> cd /mnt/data/builds
%> mkdir flang-marvell
```

2. Clone this repo:

```
%> cd flang-marvell
%> git clone https://github.com/flang-cavium/flang9.git
```

3. Copy the build Makefile:

```
%> cp flang9/Makefile.build .
```

4. You will now need to edit the build Makefile to match your build
environment. There are a few variables in the build Makefile that
need to be edited to match your build environment:

```
# Edit the following 4 paths to match your installation:
CC = /path/to/your/local/gcc/bin/gcc
CXX = /path/to/your/local/gcc/bin/g++
FC = /path/to/your/local/flang/bin/flang
GCC_RUNPATH = /path/to/your/local/gcc/lib64
```

```
# Edit the following path to match your desired setup:
CMAKE_PREFIX = /path/to/your/desired/flang9/install
```

```
# Edit this path to match your build environment setup.
LIBFFI_INCDIR = /path/to/your/libffi/header/files
```

```
# Flang libpgmath target CPU optimization
CMAKE_OPTIONS += -DLLVM_FLANG_CPU_TARGET:STRING="thunderx2t99"

For building on X86_64, set the value above to 'core-avx2'.
```

5. That's it. There are several packages that you must have installed on
your build system:

```
- a recent version of CMake
- libxml2
- libffi
- a recent version of GCC (GCC >= 7.3 preferred)
- a recent version of GNU Binutils (Binutils >= 2.32 preferred)
```

6. You are now ready to configure and build Flang 8:

```
%> gmake -f Makefile.build configure
%> cd build
%> gmake -j16 >& make.out # T-shell syntax
```
7. This version of Flang supports math function vectorization via
SLEEF (C and C++) and PGI's PGMATH (Fortran only) libraries:

```
https://sleef.org/
```

To build the SLEEF libraries, please follow the instructions at the SLEEF
web site.

The compile-line option to enable SLEEF in clang is:

```
-fveclib=SLEEF
```

To link with the SLEEF library, pass:

```
-lsleefgnuabi
```

on link-line.


