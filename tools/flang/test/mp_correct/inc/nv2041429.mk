# Copyright (c) 2018, NVIDIA CORPORATION.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SRC2 = $(SRC)/src

build: nv2041429.$(OBJX)

run:
	@echo ------------ executing test $@
	-$(RUN4) ./nv2041429.$(EXESUFFIX)

nv2041429.$(OBJX): $(SRC2)/nv2041429.f90
	@echo ------------ building test $@
	-$(FC) $(CFLAGS) $(SRC2)/nv2041429.f90 -c
	-$(FC) $(LDFLAGS) nv2041429.$(OBJX) -o nv2041429.$(EXESUFFIX)

