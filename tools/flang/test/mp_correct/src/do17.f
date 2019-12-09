!* Copyright (c) 1998, NVIDIA CORPORATION.  All rights reserved.
!*
!* Licensed under the Apache License, Version 2.0 (the "License");
!* you may not use this file except in compliance with the License.
!* You may obtain a copy of the License at
!*
!*     http://www.apache.org/licenses/LICENSE-2.0
!*
!* Unless required by applicable law or agreed to in writing, software
!* distributed under the License is distributed on an "AS IS" BASIS,
!* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!* See the License for the specific language governing permissions and
!* limitations under the License.

!	parallel do with block scheduling

	program p
	 implicit none
	 integer n
	 parameter(n=10)
	 integer a(n)
	 integer result(n)
	 integer expect(n)
	 integer expect2(n)
	 data expect /0,0,0,1,1,1,2,2,3,3/	! pgf90
	 data expect2/0,0,1,1,2,2,3,3,3,3/	! pgf77
	 integer chkalt
	 integer i,k
	 do i = 1,n
	  a(i) = -1
	 enddo
	 call sp2(a,n)
	 do i = 1,n
	  result(i) = a(i)
	 enddo
	 if (chkalt(result, expect, n) .eq. 1) then
	     call check(result,expect,n)
	 else
	     call check(result,expect2,n)
	 endif
	end

!pgi$G -y 69 4
	subroutine sp2(a,n)
	 implicit none
	 integer n
	 integer a(n)
	 integer iam, i, omp_get_thread_num
!$omp    parallel private(iam)
	  iam = omp_get_thread_num()
!$omp	  do schedule(static)
	  ! block scheduling
	   do i = 1,n
	    a(i) = iam
	   enddo
!$omp    end parallel 
	end
