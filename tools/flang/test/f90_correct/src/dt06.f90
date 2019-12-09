!*** Copyright (c) 1998, NVIDIA CORPORATION.  All rights reserved.
!***
!*** Licensed under the Apache License, Version 2.0 (the "License");
!*** you may not use this file except in compliance with the License.
!*** You may obtain a copy of the License at
!***
!***     http://www.apache.org/licenses/LICENSE-2.0
!***
!*** Unless required by applicable law or agreed to in writing, software
!*** distributed under the License is distributed on an "AS IS" BASIS,
!*** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!*** See the License for the specific language governing permissions and
!*** limitations under the License.

! more derived type parameters in modules
	module md
	  type tscope
	     integer :: scope
	  end type
	  type (tscope), parameter :: local = tscope(2)
	  type (tscope), parameter :: global = tscope(1)
	end module
	subroutine sub(a,x)
	  use md
	  type(tscope)::x
	  integer a
	  select case(x%scope)
	  case(local%scope)
	    a = 11
	  case(global%scope)
	    a = 22
	  case default
	    a = 33
	  end select
	end subroutine

	program p
	  use md
	  interface
	    subroutine sub(a,x)
	     use md
	     integer a
	     type(tscope)::x
	    end subroutine
	  end interface
	  type(tscope)::l,g,m
	  integer result(3)
	  integer expect(3)
	  data expect/11,22,33/
	  l%scope = 2
	  g%scope = 1
	  m%scope = 3
	  call sub(result(1),l)
	  call sub(result(2),g)
	  call sub(result(3),m)
	  call check(result, expect, 3)
	end
