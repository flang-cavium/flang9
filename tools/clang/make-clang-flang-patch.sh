#!/bin/bash

export PATCHDATE="`date +%Y%m%d`"
export PATCHFILE="clang-flang-patch-${PATCHDATE}.patch"

cat /dev/null > ${PATCHFILE}

for file in \
  include/clang/Basic/Builtins.def \
  include/clang/Basic/CodeGenOptions.def \
  include/clang/Basic/CodeGenOptions.h \
  include/clang/Basic/DiagnosticDriverKinds.td \
  include/clang/Basic/TargetOptions.h \
  include/clang/Driver/Action.h \
  include/clang/Driver/CC1Options.td \
  include/clang/Driver/Driver.h \
  include/clang/Driver/Options.td \
  include/clang/Driver/Phases.h \
  include/clang/Driver/ToolChain.h \
  include/clang/Driver/Types.def \
  include/clang/Driver/Types.h \
  lib/CodeGen/BackendUtil.cpp \
  lib/CodeGen/CGBuiltin.cpp \
  lib/CodeGen/CGDebugInfo.cpp \
  lib/Driver/Action.cpp \
  lib/Driver/CMakeLists.txt \
  lib/Driver/Driver.cpp \
  lib/Driver/Phases.cpp \
  lib/Driver/ToolChain.cpp \
  lib/Driver/ToolChains/Clang.cpp \
  lib/Driver/ToolChains/CommonArgs.cpp \
  lib/Driver/ToolChains/CommonArgs.h \
  lib/Driver/ToolChains/Flang.cpp \
  lib/Driver/ToolChains/Flang.h \
  lib/Driver/ToolChains/Gnu.cpp \
  lib/Driver/ToolChains/Linux.cpp \
  lib/Driver/ToolChains/Linux.h \
  lib/Driver/Types.cpp \
  lib/Frontend/CompilerInvocation.cpp \
  tools/driver/CMakeLists.txt
do
  diff --unified=16 "${file}.orig" "${file}" >> ${PATCHFILE} 2>&1
done

sed -i 's#\.orig##g' ${PATCHFILE}

