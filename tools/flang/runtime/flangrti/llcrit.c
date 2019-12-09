/*
 * Copyright (c) 2017, NVIDIA CORPORATION.  All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <pthread.h>

typedef int32_t kmp_int32;
typedef int64_t kmp_int64;

#if defined(TARGET_X8632) || defined(TARGET_LINUX_ARM32)
typedef int32_t kmp_critical_name[8];  /* must be 32 bytes */
#else
typedef struct critical_name {
  union {
    int64_t u[4];
  } __attribute__((aligned(8)));
} __attribute__((aligned(8))) kmp_critical_name;
#endif

/*
 *  * The ident structure that describes a source location.
 *   */
typedef struct ident {
  kmp_int32 reserved_1; /**<  might be used in Fortran; see above  */
  kmp_int32 flags;      /**<  also f.flags; KMP_IDENT_xxx flags;
                          KMP_IDENT_KMPC identifies this union member  */
  kmp_int32 reserved_2; /**<  not really used in Fortran any more;
                          see above */
  kmp_int32 reserved_3; /**< source[4] in Fortran, do not use for C++  */
  char const *psource; /**< String describing the source location.
                         The string is composed of semi-colon separated fields
                         which describe the source file, the function and a pair
                         of line numbers that delimit the construct. */
} ident_t;

#include <omp.h>
#include <kmp.h>

static ident_t loc = {
  0,
  KMP_IDENT_KMPC | KMP_IDENT_BARRIER_EXPL | KMP_IDENT_BARRIER_IMPL_WORKSHARE,
  0,
  0,
  ";file;func;0;0;;"
};

static void print_loc(ident_t* loc, char* buf)
{
  (void) sprintf(buf, "%i:%i:%i:%i:%s", loc->reserved_1, loc->flags,
                 loc->reserved_2, loc->reserved_3, loc->psource);
}

/* This routine makes a simple omp library call to force lazy initialization of
 * kmpc to occur early.
 */

void
_mp_p(pthread_mutex_t *mutex)
{
  (void) pthread_mutex_lock(mutex);
}

void
_mp_v(pthread_mutex_t *mutex)
{
  (void) pthread_mutex_unlock(mutex);
}

void
_mp_ptest(pthread_mutex_t *mutex)
{
}

static pthread_mutex_t mutex_cs = PTHREAD_MUTEX_INITIALIZER;

void
_mp_bcs(void)
{
  _mp_p(&mutex_cs);
}

void
_mp_ecs(void)
{
  _mp_v(&mutex_cs);
}

#ifndef __GNU_LIBRARY__
static pthread_mutex_t mutex_stdio = PTHREAD_MUTEX_INITIALIZER;
#endif

void
_mp_bcs_stdio(void)
{
#ifndef __GNU_LIBRARY__
  _mp_p(&mutex_stdio);
#endif
}

void
_mp_ecs_stdio(void)
{
#ifndef __GNU_LIBRARY__
  _mp_v(&mutex_stdio);
#endif
}

static pthread_mutex_t nest_mutex = PTHREAD_MUTEX_INITIALIZER;
static omp_nest_lock_t nest_lock;
static int is_init_nest = 0;

void
_mp_bcs_nest(void)
{
  if (!is_init_nest) {
    pthread_mutex_lock(&nest_mutex);
    if (!is_init_nest) {
      omp_init_nest_lock(&nest_lock);
      is_init_nest = 1;
    }
    pthread_mutex_unlock(&nest_mutex);
  }

  omp_set_nest_lock(&nest_lock);
}

void
_mp_ecs_nest(void)
{
  omp_unset_nest_lock(&nest_lock);
}

/* allocate and initialize a thread-private common block */
void
_mp_cdeclp(void *blk, void ***blk_tp, int size)
{
  __kmpc_threadprivate_cached(&loc, __kmpc_global_thread_num(0),
                              (void*) blk, (size_t) size, blk_tp);
}

void
_mp_cdecli(void *blk, void ***blk_tp, int size)
{
  __kmpc_threadprivate_cached(&loc, __kmpc_global_thread_num(0),
                              (void*) blk, (size_t) size, blk_tp);
}

void
_mp_cdecl(void *blk, void ***blk_tp, int size)
{
  __kmpc_threadprivate_cached(&loc, __kmpc_global_thread_num(0),
                              (void*) blk, (size_t) size, blk_tp);
}

static char *singadr;
static long singlen;

/* C/C++: copy a private stack or other other variable */
void
_mp_copypriv(char *adr, long len, int thread)
{
  if (__kmpc_global_num_threads(&loc) == 1) {
    singadr = adr;
    singlen = len;
  } else {
#if defined(TARGET_LLVM_ARM64) && \
  (defined(__GNUC__) || defined(__clang__))
    (void) __builtin_memcpy(adr, singadr, singlen);
#else
    (void) memcpy(adr, singadr, singlen);
#endif

    __kmpc_barrier(&loc, __kmpc_global_thread_num(0));
  }
}

/* copy allocatable data from the one thread to another */

void
_mp_copypriv_al(char **adr, long len, int thread)
{
  if (__kmpc_global_num_threads(&loc) == 1) {
    singadr = *adr;
    singlen = len;
  } else {
#if defined(TARGET_LLVM_ARM64) && \
  (defined(__GNUC__) || defined(__clang__))
    (void) __builtin_memcpy(*adr, singadr, singlen);
#else
    (void) memcpy(*adr, singadr, singlen);
#endif

    __kmpc_barrier(&loc, __kmpc_global_thread_num(0));
  }
}

/* C/C++: copy data from the threads' block to the other threads blocks */

void
_mp_copypriv_move(void *blk_tp, int off, int size, int single_thread)
{
  int lcpu;
  char *to;
  char *garbage = 0;


  if (__kmpc_global_num_threads(&loc) == 1) {  /* single thread */
    singadr = (char*) __kmpc_threadprivate_cached(&loc, single_thread,
                                                  garbage, (size_t) size,
                                                  blk_tp);
    singlen = size;
  } else {
    lcpu = __kmpc_global_thread_num(0);
     to = (char*) __kmpc_threadprivate_cached(&loc, lcpu, garbage,
                                              (size_t) size, blk_tp);

#if defined(TARGET_LLVM_ARM64) && \
  (defined(__GNUC__) || defined(__clang__))
     (void) __builtin_memcpy(to, singadr, size);
#else
     (void) memcpy(to, singadr, size);
#endif

     __kmpc_barrier(&loc, __kmpc_global_thread_num(0));
  }
}

/* C/C++: copy data from the threads' block to the other threads blocks.
 * Use when experiment flag 69,0x80
 */

void
_mp_copypriv_move_tls(void **blk_tp, int off, int size, int single_thread)
{
  int lcpu;
  char *to;
  char *garbage = 0;


  if (__kmpc_global_num_threads(&loc) == 1) {  /* single thread */
    if (*blk_tp == 0)
      singadr = (char*) __kmpc_threadprivate(&loc, single_thread,
                                             garbage, (size_t) size);
    else
      singadr = *blk_tp;
    singlen = size;
  } else {
    lcpu = __kmpc_global_thread_num(0);
     if (*blk_tp == 0)
       to = __kmpc_threadprivate(&loc, lcpu, garbage, (size_t)size);
     else
       to = *blk_tp;

#if defined(TARGET_LLVM_ARM64) && \
   (defined(__GNUC__) || defined(__clang__))
     (void) __builtin_memcpy(to, singadr, size);
#else
     (void) memcpy(to, singadr, size);
#endif

     __kmpc_barrier(&loc, lcpu);
  }
}

/*C: copy data from the master's block to the other threads blocks
 * Don't use: keep for backward compatibility
*/

void
_mp_copyin_move(void *blk_tp, int off, int size)
{
  char *to, *fr;
  char *garbage = 0;

  int lcpu =__kmpc_global_thread_num(0);

  if (lcpu != 0) {
    fr = __kmpc_threadprivate_cached(&loc, 0, garbage,
                                     (size_t) size, blk_tp);
    to = __kmpc_threadprivate_cached(&loc, lcpu, garbage,
                                     (size_t) size, blk_tp);
    if (to != fr)
#if (defined(TARGET_LLVM_ARM) || defined(TARGET_LLVM_ARM64)) && \
   (defined(__GNUC__) || defined(__clang__))
      (void) __builtin_memcpy(to, fr, size);
#else
      (void) memcpy(to, fr, size);
#endif

    __kmpc_barrier(&loc, lcpu);
  }
}

/* C: copy data from the master's block to the other threads blocks
 * Use when experiment flag 69,0x80
 */

void
_mp_copyin_move_tls(void *blk_tp, int off, int size)
{
  char *to, *fr;
  char *garbage = 0;

  int lcpu =__kmpc_global_thread_num(0);

  if (lcpu != 0) {
    fr =  __kmpc_threadprivate(&loc, 0, garbage, (size_t) size);
    to =  __kmpc_threadprivate(&loc, lcpu, garbage, (size_t) size);

    if (to != fr)
#if (defined(TARGET_LLVM_ARM) || defined(TARGET_LLVM_ARM64)) && \
  (defined(__GNUC__) || defined(__clang__))
      (void) __builtin_memcpy(to, fr, size);
#else
      (void) memcpy(to, fr, size);
#endif

    __kmpc_barrier(&loc, __kmpc_global_thread_num(0));
  }
}

typedef void (*assign_func_ptr) (void*, void*);

/* C++: copy data from the master's block to the other threads blocks
   using the assignment operator
	vector_size is 1 for non arrays
                       n for array[n]
 * Don't use: keep for backward compatibility
 */

void
_mp_copyin_move_cpp(void *blk_tp, int off, int class_size,
                     int vector_size,assign_func_ptr assign_op)
{
  int lcpu;
  char *to, *fr;
  char *garbage = 0;
  int i;

  lcpu =__kmpc_global_thread_num(0);

  if (lcpu != 0) {
    fr =  __kmpc_threadprivate_cached(&loc, 0, garbage,
			               (size_t) (class_size * vector_size),
					blk_tp);
    to =  __kmpc_threadprivate_cached(&loc , lcpu, garbage,
				       (size_t)(class_size * vector_size),
					blk_tp);

    for (i = 0; i < vector_size; ++i) {
        if (to != fr) {
          (*assign_op)(to, fr);
        }

	to += class_size;
	fr += class_size;
     }

    __kmpc_barrier(&loc, lcpu);
  }
}

/* C++: copy data from the master's block to the other threads blocks
   using the assignment operator
	vector_size is 1 for non arrays
                       n for array[n]
 */
void
_mp_copyin_move_cpp_new(void *blk_tp, int off, int class_size,
                       int vector_size,assign_func_ptr assign_op,
                       char* fr)
{
  int lcpu;
  char *to;
  char *garbage = 0;
  int i;

  if (!fr)
    return;

  lcpu =__kmpc_global_thread_num(0);

  to =  __kmpc_threadprivate_cached(&loc, lcpu, garbage,
				    (size_t)(class_size * vector_size),
				    blk_tp);

  for (i = 0; i < vector_size; ++i) {
    if (to != fr) {
      (*assign_op)(to, fr);
    }

    to += class_size;
    fr += class_size;
  }
}

/*
 * Use when experiment flag 69,0x80
 */
void
_mp_copyin_move_cpp_tls(void *master, void* slave, int class_size,
                     int vector_size, assign_func_ptr assign_op)
{
  char *to, *fr;
  int i;

  fr =  (char*)master;
  to =  (char*)slave;
  if (fr && to) {
     for (i = 0; i < vector_size; ++i) {
	(*assign_op)(to, fr);
	to += class_size;
	fr += class_size;
     }
  }
}

/* Copy multiple items from master to children threads.
 * Don't use: keep for backward compatibility
 */
void
_mp_copyin_move_multiple(int n_entries, void *data)
{
  int i;
  const int tid = __kmpc_global_thread_num(NULL);
  struct pair_t {size_t size; void *data;};


  if (tid != 0) {
    for (i = 0; i < n_entries; ++i) {
      struct pair_t *item = (struct pair_t*) data + i;
      void *key = item->data;
      const size_t size = item->size;
      void *to = __kmpc_threadprivate_cached(&loc, tid, NULL, size, key);
      /* FIXME: Should this be 0 or the team master?
       * I think the gtid of team master.
       */
      void *fr = __kmpc_threadprivate_cached(&loc, 0, NULL, size, key);
      if (to != fr)
#if (defined(TARGET_LLVM_ARM) || defined(TARGET_LLVM_ARM64)) && \
  (defined(__GNUC__) || defined(__clang__))
        (void) __builtin_memcpy(to, fr, size);
#else
        (void) memcpy(to, fr, size);
#endif
    }

    __kmpc_barrier(&loc, tid);
  }
}

/* copy allocatable data from the master's block to the other threads' blocks */

void
_mp_copyin_move_al(void *blk_tp, int off, long size)
{
  int lcpu;
  char *to, *fr;
  char *garbage = 0;

  lcpu = __kmpc_global_thread_num(0);

  if (lcpu != 0) {
    fr =  __kmpc_threadprivate_cached(&loc, 0, garbage,
                                      (size_t) size, blk_tp);
    to =  __kmpc_threadprivate_cached(&loc, lcpu, garbage,
                                      (size_t) size, blk_tp);
    if (to && to != fr) {
#if (defined(TARGET_LLVM_ARM) || defined(TARGET_LLVM_ARM64)) && \
  (defined(__GNUC__) || defined(__clang__))
      (void) __builtin_memcpy(to, fr, size);
#else
      (void) memcpy(to, fr, size);
#endif
    }

    __kmpc_barrier(&loc, lcpu);
  }
}

/* Handler for __kmpc_copyprivate 'cpy_func'
 * See how we marshall data in make_copypriv_array()  in expsmp.c.
 */
void
_mp_copypriv_kmpc(void *dest, void *src)
{
  struct pair_t {
    size_t *size;
    void *data;
  };

  const struct pair_t *to   = (struct pair_t *)dest;
  const struct pair_t *from = (struct pair_t *)src;

  for ( ; from->size; ++from, ++to) {
    if (to->data != from->data)
#if (defined(TARGET_LLVM_ARM) || defined(TARGET_LLVM_ARM64)) && \
  (defined(__GNUC__) || defined(__clang__))
      (void) __builtin_memcpy(to->data, from->data, *from->size);
#else
      (void) memcpy(to->data, from->data, *from->size);
#endif
  }
}

/* duplicate kmpc_threadprivate_cached but we assume each thread has its
 * own addr in its own [tls] address space so that it does not need to
 * access memory in other thread's area. Use when experiment flag 69,0x80
 */
void*
_mp_get_threadprivate(ident_t* ident, kmp_int32 gtid, void* tpv,
                      size_t size, void** addr)
{
  if (*addr == NULL) {
    *addr =  __kmpc_threadprivate(ident, gtid, tpv, size);
  }

  return *addr;
}

