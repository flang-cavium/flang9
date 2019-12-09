# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -iterations=3 -timeline -register-file-stats < %s | FileCheck %s

# The register move from XMM0 to XMM1 can be eliminated at register renaming
# stage. So, it should not consume pipeline resources.

xorps %xmm0, %xmm0
movaps %xmm0, %xmm1
addps %xmm1, %xmm1

# CHECK:      Iterations:        3
# CHECK-NEXT: Instructions:      9
# CHECK-NEXT: Total Cycles:      9
# CHECK-NEXT: Total uOps:        9

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               1.00
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      0     0.25                        xorps	%xmm0, %xmm0
# CHECK-NEXT:  1      1     1.00                        movaps	%xmm0, %xmm1
# CHECK-NEXT:  1      3     1.00                        addps	%xmm1, %xmm1

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    9
# CHECK-NEXT: Max number of mappings used:         8

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SBDivider
# CHECK-NEXT: [1]   - SBFPDivider
# CHECK-NEXT: [2]   - SBPort0
# CHECK-NEXT: [3]   - SBPort1
# CHECK-NEXT: [4]   - SBPort4
# CHECK-NEXT: [5]   - SBPort5
# CHECK-NEXT: [6.0] - SBPort23
# CHECK-NEXT: [6.1] - SBPort23

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     xorps	%xmm0, %xmm0
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     movaps	%xmm0, %xmm1
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     addps	%xmm1, %xmm1

# CHECK:      Timeline view:
# CHECK-NEXT: Index     012345678

# CHECK:      [0,0]     DR   .  .   xorps	%xmm0, %xmm0
# CHECK-NEXT: [0,1]     DeER .  .   movaps	%xmm0, %xmm1
# CHECK-NEXT: [0,2]     D=eeeER .   addps	%xmm1, %xmm1
# CHECK-NEXT: [1,0]     D-----R .   xorps	%xmm0, %xmm0
# CHECK-NEXT: [1,1]     .DeE--R .   movaps	%xmm0, %xmm1
# CHECK-NEXT: [1,2]     .D=eeeER.   addps	%xmm1, %xmm1
# CHECK-NEXT: [2,0]     .D-----R.   xorps	%xmm0, %xmm0
# CHECK-NEXT: [2,1]     .D=eE--R.   movaps	%xmm0, %xmm1
# CHECK-NEXT: [2,2]     . D=eeeER   addps	%xmm1, %xmm1

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     0.0    0.0    3.3       xorps	%xmm0, %xmm0
# CHECK-NEXT: 1.     3     1.3    1.3    1.3       movaps	%xmm0, %xmm1
# CHECK-NEXT: 2.     3     2.0    0.0    0.0       addps	%xmm1, %xmm1
