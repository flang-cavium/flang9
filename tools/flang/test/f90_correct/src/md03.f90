! Copyright (c) 1998, NVIDIA CORPORATION.  All rights reserved.
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.
!
! test that PRIVATE/PUBLIC can be used on names that conflict with derived 
! type members

module foo
  integer, private :: bar
  type, public :: baz
     integer :: bar
  end type baz
  contains
   subroutine init(i)
    integer i
    bar = i
   end subroutine
   integer function getval
     getval = bar
   end function
   subroutine inc(b)
    type(baz)::b
    b%bar = b%bar * 2 + 1
   end subroutine
end module foo

module baq
  integer, public :: bar
end module

subroutine s1(result,n)
 use foo
 use baq
 integer result(:),n
 type(baz) :: b
 call init(90)
 n = n + 1
 result(n) = bar
 n = n + 1
 result(n) = getval()
 b%bar = 100
 call inc(b)
 n = n + 1
 result(n) = b%bar
end subroutine

subroutine s2(result,n)
 use baq
 use foo
 integer result(:),n
 type(baz) :: b
 call init(180)
 n = n + 1
 result(n) = bar
 n = n + 1
 result(n) = getval()
 b%bar = 200
 call inc(b)
 n = n + 1
 result(n) = b%bar
end subroutine

program p
 interface
  subroutine s1(result,n)
   integer result(:),n
  end subroutine
  subroutine s2(result,n)
   integer result(:),n
  end subroutine
 end interface
 integer,parameter::nr=10
 integer result(nr), expect(nr),n
 data expect/999,280,999,90,201,999,180,401,999,400/

 n = 0
 call s3(result,n)
 call s1(result,n)
 call s2(result,n)
 call s4(result,n)
 !print *,result
 call check(result,expect,nr)

 contains

subroutine s3(result,n)
 use baq
 use foo
 integer result(:),n
 bar = 999
 call init(280)
 n = n + 1
 result(n) = bar
 n = n + 1
 result(n) = getval()
end subroutine

subroutine s4(result,n)
 use foo
 use baq
 integer result(:),n
 call init(400)
 n = n + 1
 result(n) = bar
 n = n + 1
 result(n) = getval()
end subroutine

end program

