//==--- AArch64BranchTargetAligner.cpp - Branch target alignments on T99 ---==//
//
//                     The LLVM Compiler Infrastructure
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
// \file Determine special treatment for branch targets on ThunderX2T99.
//===----------------------------------------------------------------------===//

#include "AArch64.h"
#include "AArch64RegisterInfo.h"
#include "AArch64Subtarget.h"
#include "AArch64BranchTargetAligner.h"
#include "MCTargetDesc/AArch64MCExpr.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "MCTargetDesc/AArch64FixupKinds.h"
#include "AArch64GenInstrInfo.inc"
using namespace llvm;

static cl::opt<bool> EnableBranchTargetAlignment(
  "aarch64-enable-branch-target-alignment", cl::Hidden, cl::init(false),
  cl::desc("Enable special alignment of branch targets."));

static cl::opt<unsigned> BranchTargetAlignment(
  "aarch64-branch-target-alignment", cl::Hidden, cl::init(16),
  cl::desc("Align branch targets on this boundary (in bytes)."));

static cl::opt<bool> BranchTargetAlignBcc(
  "aarch64-branch-target-align-bcc", cl::Hidden, cl::init(true),
  cl::desc("Align branch targets for Bcc."));

static cl::opt<bool> BranchTargetAlignBL(
  "aarch64-branch-target-align-bl", cl::Hidden, cl::init(false),
  cl::desc("Align branch targets for BL."));

static cl::opt<bool> BranchTargetAlignBLR(
  "aarch64-branch-target-align-blr", cl::Hidden, cl::init(true),
  cl::desc("Align branch targets for BLR."));

static cl::opt<bool> BranchTargetAlignBCond(
  "aarch64-branch-target-align-bcond", cl::Hidden, cl::init(true),
  cl::desc("Align branch targets for branch-on-condition (b.eq|b.ne|etc)."));

static cl::opt<bool> BranchTargetAlignCBZ(
  "aarch64-branch-target-align-cbz", cl::Hidden, cl::init(true),
  cl::desc("Align branch targets for cbz|cbnz."));

/// Be careful with TBZ|TBNZ. Chances are it will not work.
static cl::opt<bool> BranchTargetAlignTBZ(
  "aarch64-branch-target-align-tbz", cl::Hidden, cl::init(false),
  cl::desc("Align branch targets for tbz|tbnz."));

namespace llvm {

static const char* getOpcodeName(unsigned Opcode) {
  const char *Name = "<unknown>";

  switch (Opcode) {
  default:
    break;
  case AArch64::B:
    Name = "AArch64::B";
    break;
  case AArch64::Bcc:
    Name = "AArch64::Bcc";
    break;
  case AArch64::BR:
    Name = "AArch64::BR";
    break;
  case AArch64::BRAA:
    Name = "AArch64::BRAA";
    break;
  case AArch64::BRAAZ:
    Name = "AArch64::BRAAZ";
    break;
  case AArch64::BRAB:
    Name = "AArch64::BRAB";
    break;
  case AArch64::BRABZ:
    Name = "AArch64::BRABZ";
    break;
  case AArch64::BL:
    Name = "AArch64::BL";
    break;
  case AArch64::BLR:
    Name = "AArch64::BLR";
    break;
  case AArch64::BLRAA:
    Name = "AArch64::BLRAA";
    break;
  case AArch64::BLRAAZ:
    Name = "AArch64::BLRAAZ";
    break;
  case AArch64::BLRAB:
    Name = "AArch64::BLRAB";
    break;
  case AArch64::BLRABZ:
    Name = "AArch64::BLRABZ";
    break;
  case AArch64::CBZW:
    Name = "AArch64::CBZW";
    break;
  case AArch64::CBZX:
    Name = "AArch64::CBZX";
    break;
  case AArch64::CBNZW:
    Name = "AArch64::CBNZW";
    break;
  case AArch64::CBNZX:
    Name = "AArch64::CBNZX";
    break;
  case AArch64::CCMPWr:
    Name = "AArch64::CCMPWr";
    break;
  case AArch64::CCMPXr:
    Name = "AArch64::CCMPXr";
    break;
  case AArch64::G_FCMP:
    Name = "AArch64::G_FCMP";
    break;
  case AArch64::G_ICMP:
    Name = "AArch64::G_ICMP";
    break;
  case AArch64::TBZW:
    Name = "AArch64::TBZW";
    break;
  case AArch64::TBZX:
    Name = "AArch64::TBZX";
    break;
  case AArch64::TBNZW:
    Name = "AArch64::TBNZW";
    break;
  case AArch64::TBNZX:
    Name = "AArch64::TBNZX";
    break;
  case AArch64::RET:
    Name = "AArch64::RET";
    break;
  case AArch64::RETAA:
    Name = "AArch64::RETAA";
    break;
  case AArch64::RETAB:
    Name = "AArch64::RETAB";
    break;
  case AArch64::SVC:
    Name = "AArch64::SVC";
    break;
  }

  return Name;
}

bool AArch64BranchTargetAligner::needsSpecialAlignment(StringRef CPU,
                                                       unsigned Opcode) {
  if (CPU != "thunderx2t99")
    return false;

  switch (Opcode) {
  default:
    return false;
    break;
  case AArch64::B:
  case AArch64::Bcc:
  case AArch64::BR:
  case AArch64::BRAA:
  case AArch64::BRAAZ:
  case AArch64::BRAB:
  case AArch64::BRABZ:
  case AArch64::BL:
  case AArch64::BLR:
  case AArch64::BLRAA:
  case AArch64::BLRAAZ:
  case AArch64::BLRAB:
  case AArch64::BLRABZ:
  case AArch64::CBZW:
  case AArch64::CBZX:
  case AArch64::CBNZW:
  case AArch64::CBNZX:
  case AArch64::CCMPWr:
  case AArch64::CCMPXr:
  case AArch64::G_FCMP:
  case AArch64::G_ICMP:
  case AArch64::TBZW:
  case AArch64::TBZX:
  case AArch64::TBNZW:
  case AArch64::TBNZX:
  case AArch64::RET:
  case AArch64::RETAA:
  case AArch64::RETAB:
  case AArch64::SVC:
    return true;
    break;
  }

  return false;
}

static bool isFixup(unsigned Opcode) {
  switch (Opcode) {
  case AArch64::fixup_aarch64_add_imm12:
  case AArch64::fixup_aarch64_ldr_pcrel_imm19:
  case AArch64::fixup_aarch64_ldst_imm12_scale1:
  case AArch64::fixup_aarch64_ldst_imm12_scale16:
  case AArch64::fixup_aarch64_ldst_imm12_scale2:
  case AArch64::fixup_aarch64_ldst_imm12_scale4:
  case AArch64::fixup_aarch64_ldst_imm12_scale8:
  case AArch64::fixup_aarch64_movw:
  case AArch64::fixup_aarch64_pcrel_adr_imm21:
  case AArch64::fixup_aarch64_pcrel_adrp_imm21:
  case AArch64::fixup_aarch64_pcrel_branch14:
  case AArch64::fixup_aarch64_pcrel_branch19:
  case AArch64::fixup_aarch64_pcrel_branch26:
  case AArch64::fixup_aarch64_pcrel_call26:
  case AArch64::fixup_aarch64_tlsdesc_call:
    return true;
    break;
  default:
    return false;
    break;
  }
}

static bool isBranch(const MCInst &Inst) {
  unsigned Opcode = Inst.getOpcode();

  switch (Opcode) {
  default:
    return false;
    break;
  case AArch64::B:
  case AArch64::Bcc:
  case AArch64::BR:
  case AArch64::BRAA:
  case AArch64::BRAAZ:
  case AArch64::BRAB:
  case AArch64::BRABZ:
  case AArch64::BL:
  case AArch64::BLR:
  case AArch64::BLRAA:
  case AArch64::BLRAAZ:
  case AArch64::BLRAB:
  case AArch64::BLRABZ:
  case AArch64::CBZW:
  case AArch64::CBZX:
  case AArch64::CBNZW:
  case AArch64::CBNZX:
  case AArch64::CCMPWr:
  case AArch64::CCMPXr:
  case AArch64::G_FCMP:
  case AArch64::G_ICMP:
  case AArch64::TBZW:
  case AArch64::TBZX:
  case AArch64::TBNZW:
  case AArch64::TBNZX:
  case AArch64::RET:
  case AArch64::RETAA:
  case AArch64::RETAB:
  case AArch64::SVC:
    return true;
    break;
  }

  return false;
}

static bool getBranchLabel(const MCInst &Inst) {
  if (!isBranch(Inst))
    return false;

  unsigned Opcode = Inst.getOpcode();

  if (isFixup(Opcode))
    return false;

  if (Opcode == AArch64::RET || Opcode == AArch64::RETAA ||
      Opcode == AArch64::RETAB)
    return true;

  if (!EnableBranchTargetAlignment.getValue())
    return false;

  if (Inst.getNumOperands() < 1)
    return false;

  if (Inst.getNumOperands() == 1) {
    const MCOperand &FirstOperand = Inst.getOperand(0);
    if (!FirstOperand.isExpr())
      return false;

    const MCSymbolRefExpr *RefExpr =
      static_cast<const MCSymbolRefExpr*>(FirstOperand.getExpr());

    if (RefExpr == nullptr)
      return false;

    uint32_t VK = static_cast<uint32_t>(RefExpr->getKind());

    if (VK > MCSymbolRefExpr::VK_DTPREL) {
      if (const AArch64MCExpr *AARefExpr =
          dyn_cast<const AArch64MCExpr>(RefExpr)) {
        VK = AARefExpr->getKind();
      } else
        return false;
    }

    if (VK == MCSymbolRefExpr::VK_Invalid || VK == MCSymbolRefExpr::VK_None ||
        VK >= AArch64MCExpr::VK_INVALID || VK == AArch64MCExpr::VK_NONE) {
      switch (Opcode) {
      case AArch64::B:
        return BranchTargetAlignBCond.getValue();
        break;
      case AArch64::BL:
        return BranchTargetAlignBL.getValue();
        break;
      case AArch64::BLR:
        return BranchTargetAlignBLR.getValue();
        break;
      case AArch64::CBZW:
      case AArch64::CBZX:
      case AArch64::CBNZW:
      case AArch64::CBNZX:
        return BranchTargetAlignCBZ.getValue();
        break;
      case AArch64::TBZW:
      case AArch64::TBZX:
      case AArch64::TBNZW:
      case AArch64::TBNZX:
        return BranchTargetAlignTBZ.getValue();
        break;
      case AArch64::Bcc:
        return BranchTargetAlignBcc.getValue();
        break;
      default:
        return false;
        break;
      }
    }

    return true;
  } else if (Inst.getNumOperands() == 2) {
    const MCOperand &FirstOperand = Inst.getOperand(0);
    const MCOperand &SecondOperand = Inst.getOperand(1);

    if (!FirstOperand.isExpr() && !SecondOperand.isExpr())
      return false;

    const MCSymbolRefExpr *RefExpr = nullptr;
    if (FirstOperand.isExpr())
      RefExpr = static_cast<const MCSymbolRefExpr*>(FirstOperand.getExpr());
    else if (SecondOperand.isExpr())
      RefExpr = static_cast<const MCSymbolRefExpr*>(SecondOperand.getExpr());

    if (RefExpr == nullptr)
      return false;

    uint32_t VK = static_cast<uint32_t>(RefExpr->getKind());

    if (VK > MCSymbolRefExpr::VK_DTPREL) {
      if (const AArch64MCExpr *AARefExpr =
          dyn_cast<const AArch64MCExpr>(RefExpr)) {
        VK = AARefExpr->getKind();
      } else
        return false;
    }

    if (VK == MCSymbolRefExpr::VK_Invalid || VK == MCSymbolRefExpr::VK_None ||
        VK >= AArch64MCExpr::VK_INVALID || VK == AArch64MCExpr::VK_NONE) {
      switch (Opcode) {
      case AArch64::B:
        return BranchTargetAlignBCond.getValue();
        break;
      case AArch64::BL:
        return BranchTargetAlignBL.getValue();
        break;
      case AArch64::BLR:
        return BranchTargetAlignBLR.getValue();
        break;
      case AArch64::CBZW:
      case AArch64::CBZX:
      case AArch64::CBNZW:
      case AArch64::CBNZX:
        return BranchTargetAlignCBZ.getValue();
        break;
      case AArch64::TBZW:
      case AArch64::TBZX:
      case AArch64::TBNZW:
      case AArch64::TBNZX:
        return BranchTargetAlignTBZ.getValue();
        break;
      case AArch64::Bcc:
        return BranchTargetAlignBcc.getValue();
        break;
      default:
        return false;
        break;
      }
    }

    return true;
  } else if (Inst.getNumOperands() == 3) {
    const MCOperand &FirstOperand = Inst.getOperand(0);
    const MCOperand &SecondOperand = Inst.getOperand(1);
    const MCOperand &ThirdOperand = Inst.getOperand(2);

    if (!FirstOperand.isExpr() && !SecondOperand.isExpr() &&
        !ThirdOperand.isExpr())
      return false;

    const MCSymbolRefExpr *RefExpr = nullptr;

    if (FirstOperand.isExpr())
      RefExpr = static_cast<const MCSymbolRefExpr*>(FirstOperand.getExpr());
    else if (SecondOperand.isExpr())
      RefExpr = static_cast<const MCSymbolRefExpr*>(SecondOperand.getExpr());
    else if (ThirdOperand.isExpr())
      RefExpr = static_cast<const MCSymbolRefExpr*>(ThirdOperand.getExpr());

    if (RefExpr == nullptr)
      return false;

    uint32_t VK = static_cast<uint32_t>(RefExpr->getKind());

    if (VK > MCSymbolRefExpr::VK_DTPREL) {
      if (const AArch64MCExpr *AARefExpr =
          dyn_cast<const AArch64MCExpr>(RefExpr)) {
        VK = AARefExpr->getKind();
      } else
        return false;
    }

    if (VK == MCSymbolRefExpr::VK_Invalid || VK == MCSymbolRefExpr::VK_None ||
        VK >= AArch64MCExpr::VK_INVALID || VK == AArch64MCExpr::VK_NONE) {
      switch (Opcode) {
      case AArch64::B:
        return BranchTargetAlignBCond.getValue();
        break;
      case AArch64::BL:
        return BranchTargetAlignBL.getValue();
        break;
      case AArch64::BLR:
        return BranchTargetAlignBLR.getValue();
        break;
      case AArch64::CBZW:
      case AArch64::CBZX:
      case AArch64::CBNZW:
      case AArch64::CBNZX:
        return BranchTargetAlignCBZ.getValue();
        break;
      case AArch64::TBZW:
      case AArch64::TBZX:
      case AArch64::TBNZW:
      case AArch64::TBNZX:
        return BranchTargetAlignTBZ.getValue();
        break;
      case AArch64::Bcc:
        return BranchTargetAlignBcc.getValue();
        break;
      default:
        return false;
        break;
      }
    }

    return true;
  }

  return false;
}

unsigned
AArch64BranchTargetAligner::getBranchTargetAlignment(const MCInst &Inst) {
  unsigned Opcode = Inst.getOpcode();
  unsigned NumOperands = Inst.getNumOperands();

  if (isFixup(Opcode) || Opcode == AArch64::NOP || Opcode == AArch64::ADRP)
    return 0;

  if (Opcode == AArch64::RET || Opcode == AArch64::RETAA ||
      Opcode == AArch64::RETAB)
    return BranchTargetAlignment.getValue();

  bool LabelInst = getBranchLabel(Inst);
  bool CanAlign = true;

  if (LabelInst)
    return BranchTargetAlignment.getValue();

  if (!EnableBranchTargetAlignment.getValue())
    return 0;

  for (unsigned I = 0; I < NumOperands; ++I) {
    if (Inst.getOperand(I).isExpr()) {
      const MCExpr *MCE = Inst.getOperand(I).getExpr();
      if (MCE && (MCE->getKind() == MCExpr::Binary ||
                  MCE->getKind() == MCExpr::Constant ||
                  MCE->getKind() == MCExpr::Unary)) {
        switch (Opcode) {
        case AArch64::B:
          CanAlign = BranchTargetAlignBCond.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::Bcc:
          CanAlign = BranchTargetAlignBcc.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::BL:
          CanAlign = BranchTargetAlignBL.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::BR:
        case AArch64::BLR:
        case AArch64::BLRAA:
        case AArch64::BLRAAZ:
        case AArch64::BLRAB:
        case AArch64::BLRABZ:
          CanAlign = BranchTargetAlignBLR.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::CBZW:
        case AArch64::CBZX:
        case AArch64::CBNZW:
        case AArch64::CBNZX:
          CanAlign = BranchTargetAlignCBZ.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::TBZW:
        case AArch64::TBZX:
        case AArch64::TBNZW:
        case AArch64::TBNZX:
          CanAlign = false;
          goto bailout;
          break;
        default:
          CanAlign = false;
          goto bailout;
          break;
        }
      } else {
        switch (Opcode) {
        case AArch64::B:
          CanAlign = BranchTargetAlignBCond.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::Bcc:
          CanAlign = BranchTargetAlignBcc.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::BL:
          CanAlign = BranchTargetAlignBL.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::BR:
        case AArch64::BLR:
        case AArch64::BLRAA:
        case AArch64::BLRAAZ:
        case AArch64::BLRAB:
        case AArch64::BLRABZ:
          CanAlign = BranchTargetAlignBLR.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::CBZW:
        case AArch64::CBZX:
        case AArch64::CBNZW:
        case AArch64::CBNZX:
          CanAlign = BranchTargetAlignCBZ.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::TBZW:
        case AArch64::TBZX:
        case AArch64::TBNZW:
        case AArch64::TBNZX:
          CanAlign = false;
          goto bailout;
          break;
        default:
          CanAlign = false;
          goto bailout;
          break;
        }
      }
    } else if (Inst.getOperand(I).isInst()) {
      const MCInst *MCI = Inst.getOperand(I).getInst();
      if (MCI && isFixup(MCI->getOpcode())) {
        CanAlign = false;
        goto bailout;
        break;
      } else {
        switch (Opcode) {
        case AArch64::B:
          CanAlign = BranchTargetAlignBCond.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::Bcc:
          CanAlign = BranchTargetAlignBcc.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::BL:
          CanAlign = BranchTargetAlignBL.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::BR:
        case AArch64::BLR:
        case AArch64::BLRAA:
        case AArch64::BLRAAZ:
        case AArch64::BLRAB:
        case AArch64::BLRABZ:
          CanAlign = BranchTargetAlignBLR.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::CBZW:
        case AArch64::CBZX:
        case AArch64::CBNZW:
        case AArch64::CBNZX:
          CanAlign = BranchTargetAlignCBZ.getValue();
          if (!CanAlign)
            goto bailout;
          break;
        case AArch64::TBZW:
        case AArch64::TBZX:
        case AArch64::TBNZW:
        case AArch64::TBNZX:
          CanAlign = false;
          goto bailout;
          break;
        default:
          CanAlign = false;
          goto bailout;
          break;
        }
      }
    } else if (Inst.getOperand(I).isImm()) {
      switch (Opcode) {
      case AArch64::B:
        CanAlign = BranchTargetAlignBCond.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::Bcc:
        CanAlign = BranchTargetAlignBcc.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::BL:
        CanAlign = BranchTargetAlignBL.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::BR:
      case AArch64::BLR:
      case AArch64::BLRAA:
      case AArch64::BLRAAZ:
      case AArch64::BLRAB:
      case AArch64::BLRABZ:
        CanAlign = BranchTargetAlignBLR.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::CBZW:
      case AArch64::CBZX:
      case AArch64::CBNZW:
      case AArch64::CBNZX:
        CanAlign = BranchTargetAlignCBZ.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::TBZW:
      case AArch64::TBZX:
      case AArch64::TBNZW:
      case AArch64::TBNZX:
        CanAlign = false;
        goto bailout;
        break;
      default:
        CanAlign = false;
        goto bailout;
        break;
      }

      if (!CanAlign)
        goto bailout;
    } else if (Inst.getOperand(I).isFPImm()) {
      CanAlign = false;
      goto bailout;
      break;
    } else if (Inst.getOperand(I).isReg()) {
      switch (Opcode) {
      case AArch64::B:
        CanAlign = BranchTargetAlignBCond.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::Bcc:
        CanAlign = BranchTargetAlignBcc.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::BL:
        CanAlign = BranchTargetAlignBL.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::BR:
      case AArch64::BLR:
      case AArch64::BLRAA:
      case AArch64::BLRAAZ:
      case AArch64::BLRAB:
      case AArch64::BLRABZ:
        CanAlign = BranchTargetAlignBLR.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::CBZW:
      case AArch64::CBZX:
      case AArch64::CBNZW:
      case AArch64::CBNZX:
        CanAlign = BranchTargetAlignCBZ.getValue();
        if (!CanAlign)
          goto bailout;
        break;
      case AArch64::TBZW:
      case AArch64::TBZX:
      case AArch64::TBNZW:
      case AArch64::TBNZX:
        CanAlign = false;
        goto bailout;
        break;
      default:
        CanAlign = false;
        goto bailout;
        break;
      }

      if (!CanAlign)
        goto bailout;
    } else if (!Inst.getOperand(I).isValid()) {
      CanAlign = false;
      goto bailout;
      break;
    }
  }

bailout:
  if (CanAlign && LabelInst)
    return BranchTargetAlignment.getValue();

  return 0;
}

MCInst AArch64BranchTargetAligner::createNopInstruction() {
  MCInst Inst;
  Inst.setOpcode(AArch64::NOP);
  return Inst;
}

} // namespace llvm

