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

!	OpenMP verison of matmul

      integer result(1), expect(1), itest
      result(1) = itest()
      data expect/200/
      call check(result, expect, 1)
      end
      integer function itest
c
      integer i, j, k
      integer size, m, n, p
      parameter (size=200)
      parameter (m=size,n=size,p=size)
      real*8 a, b, c, arow
      dimension a(m,n), b(n,p), c(n,p), arow(n)
      integer omp_get_thread_num
      integer omp_get_num_threads
c
      integer l
c
      do i = 1, m
      do j = 1, n
         a(i,j) = 1.0
      enddo
      enddo
      do i = 1, n
      do j = 1, p
         b(i,j) = 1.0
      enddo
      enddo
c
!$omp parallel 
!!      print *, '#t ', omp_get_thread_num()
!!      print *, '#h ', omp_get_num_threads()
!$omp do
         do j = 1, p
            do i = 1, m
               c(i,j) = 0.0
            enddo
         enddo
         do i = 1, m
!$omp do
            do ii = 1, n
               arow(ii) = a(i,ii)
            enddo
!$omp do
            do j = 1, p
               do k = 1, n
                  c(i,j) = c(i,j) + arow(k) * b(k,j)
               enddo
            enddo
         enddo
!$omp end parallel
c
!!      print *, "c(1,1) = ", c(1,1)
c
      itest = c(1,1) + 0.005
      end
