! Copyright (c) 2010, NVIDIA CORPORATION.  All rights reserved.
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

module shape_base_mod

type shape
        integer :: color
        logical :: filled
        integer :: x
        integer :: y
end type shape

end module shape_base_mod

module shape_mod

use shape_base_mod

type, EXTENDS ( shape ) :: rectangle
        integer :: the_length
        integer :: the_width
end type rectangle

type, extends (rectangle) :: square
end type square

end module shape_mod

subroutine test_types(s1,s2,z,results)
use shape_mod
class(shape)::s1, s2
class(shape)::z(:)
integer results(2)

results(1) = SAME_TYPE_AS(s1,z)
results(2) = SAME_TYPE_AS(z,s2)
end subroutine


program p
USE CHECK_MOD
use shape_mod

interface
subroutine test_types(s1,s2,z,results)
use shape_mod
class(shape)::s1, s2
class(shape)::z(:)
integer results(2)
end subroutine
end interface

type(square)::arr(10)
integer results(2)
integer expect(2)
data expect /.true.,.false./
data results /.false.,.true./
type(square) :: s
type(rectangle) :: r

call test_types(s,r,arr,results)

call check(expect,results,2)

end


