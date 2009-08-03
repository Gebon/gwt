# Copyright 2009 Google Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

# This Makefile fragment sets the following make variables according to the
# current platform:
#   ARCH - the Mozilla architecture name, such as x86, x86_64, ppc, etc
#   FLAG32BIT - 32 or 64
#   MARCH - the Mac architecture, such as i386 or ppc
#   OS - linux, mac, or sun
#   CFLAGS - appropriate C compiler flags for this platform
#   CXXFLAGS - appropriate C++ compiler flags for this platform
# Also, various stanard make variables are overridden if necessary, such as AR
#
# If ARCH is already set, that is used instead of uname -m to get the
# architecture to build.  This can be used to build a 32-bit plugin on a 64-bit
# platform, for example: make ARCH=x86

ARCH ?= $(shell uname -m)

# default is 32 bits
FLAG32BIT=32

# Figure out 64-bit platforms, canonicalize ARCH and MARCH
ifeq ($(ARCH),x86_64)
FLAG32BIT=64
else ifeq ($(ARCH),sparc)
FLAG32BIT=64
else ifeq ($(ARCH),alpha)
FLAG32BIT=64
else ifeq ($(ARCH),ia64)
FLAG32BIT=64
else ifeq ($(ARCH),athlon)
ARCH=x86
else ifeq ($(ARCH),i386)
ARCH=x86
else ifeq ($(ARCH),i486)
ARCH=x86
else ifeq ($(ARCH),i586)
ARCH=x86
else ifeq ($(ARCH),i686)
ARCH=x86
else ifeq ($(ARCH),i86pc)
ARCH=x86
else ifeq ($(ARCH),Macintosh)
ARCH=ppc
endif
MARCH=$(ARCH)
ifeq ($(ARCH),x86)
MARCH=i386
endif

# Set OS as well as CFLAGS, CXX, and other common make variables
ifeq ($(shell uname),Linux)
OS=linux
CFLAGS= -g -O2 -fPIC $(INC) -rdynamic -m$(FLAG32BIT)
else ifeq ($(shell uname),Darwin)
OS=mac
CFLAGS= -g -O2 -fPIC $(INC) -D__mac -arch $(MARCH)
AR=libtool
ARFLAGS=-static -o
else ifeq ($(shell uname),SunOS)
OS=sun
#CFLAGS=-fast -g0 -Kpic $(INC) -Bdynamic -noex
# SunC appears to miscompile Socket::writeByte by not incrementing the
# buffer pointer, so no optimization for now
#CFLAGS=-g -Kpic $(INC) -Bdynamic -noex
CFLAGS= -g0 -Kpic -noex -xO1 -xlibmil -xlibmopt -features=tmplife -xbuiltin=%all -mt $(INC)
CXX= CC
endif
CXXFLAGS = $(CFLAGS)
