class AArch64::Parser

rule
  instructions
    : instructions instruction
    | instruction
    ;

  instruction
    : insn EOL;

  insn
    : adc
    | adcs
    | ADD add_body { val[1].apply(@asm, val[0]) }
    | ADDS add_body { val[1].apply(@asm, val[0]) }
    | ADR Xd COMMA imm_or_label { @asm.adr(val[1], val[3]) }
    | ADRP Xd COMMA imm_or_label { @asm.adrp(val[1], val[3]) }
    | AND and_body { val[1].apply(@asm, val[0]) }
    | ANDS and_body { val[1].apply(@asm, val[0]) }
    | asr  { val[0].apply(@asm, :asr) }
    | at
    | autda
    | b
    | bfi
    | bfxil
    | bic
    | bics
    | bl
    | blr
    | br
    | BRK imm { @asm.brk(val[1]) }
    | CBNZ reg_imm_or_label { val[1].apply(@asm, val[0]) }
    | CBZ reg_imm_or_label { val[1].apply(@asm, val[0]) }
    | cinc
    | cinv
    | clrex
    | CLS reg_reg { val[1].apply(@asm, val[0]) }
    | CLZ reg_reg { val[1].apply(@asm, val[0]) }
    | cmn
    | cmp
    | cneg
    | crc32
    | crc32c
    | cset
    | csetm
    | dc
    | DCPS1 { @asm.dcps1 }
    | DCPS2 { @asm.dcps2 }
    | DCPS3 { @asm.dcps3 }
    | dmb
    | DRPS { @asm.drps }
    | dsb
    | eor
    | eon
    | ERET { @asm.eret }
    | HINT imm { @asm.hint(val[1]) }
    | HLT imm { @asm.hlt(val[1]) }
    | HVC imm { @asm.hvc(val[1]) }
    | extr
    | ic
    | isb
    | cond_fours
    | loads
    | lsl
    | lsr
    | MADD reg_reg_reg_reg { val[1].apply(@asm, val[0]) }
    | MNEG reg_reg_reg { val[1].apply(@asm, val[0]) }
    | mov
    | MOVN movz_body { val[1].apply(@asm, val[0]) }
    | MOVK movz_body { val[1].apply(@asm, val[0]) }
    | MOVZ movz_body { val[1].apply(@asm, val[0]) }
    | mrs
    | msr
    | MSUB reg_reg_reg_reg { val[1].apply(@asm, val[0]) }
    | MUL reg_reg_reg { val[1].apply(@asm, val[0]) }
    | mvn
    | neg
    | negs
    | NGC reg_reg { val[1].apply(@asm, val[0]) }
    | NGCS reg_reg { val[1].apply(@asm, val[0]) }
    | NOP { @asm.nop }
    | orn
    | orr
    | prfm
    | prfum
    | PSSBB { @asm.pssbb }
    | RBIT reg_reg { val[1].apply(@asm, val[0]) }
    | ret
    | REV reg_reg { val[1].apply(@asm, val[0]) }
    | REV16 reg_reg { val[1].apply(@asm, val[0]) }
    | REV32 xd_xd { val[1].apply(@asm, val[0]) }
    | ror
    | SBC reg_reg_reg { val[1].apply(@asm, val[0]) }
    | SBCS reg_reg_reg { val[1].apply(@asm, val[0]) }
    | SBFIZ reg_reg_imm_imm { val[1].apply(@asm, val[0]) }
    | SBFX reg_reg_imm_imm { val[1].apply(@asm, val[0]) }
    | SDIV reg_reg_reg { val[1].apply(@asm, val[0]) }
    | SEV { @asm.sev }
    | SEVL { @asm.sevl }
    | SMADDL smaddl_params { val[1].apply(@asm, val[0]) }
    | SMC imm { @asm.smc(val[1]) }
    | SMNEGL xd_wd_wd { val[1].apply(@asm, val[0]) }
    | SMSUBL smaddl_params { val[1].apply(@asm, val[0]) }
    | SMULH xd_xd_xd { val[1].apply(@asm, val[0]) }
    | SMULL xd_wd_wd { val[1].apply(@asm, val[0]) }
    | SSBB { @asm.ssbb }
    | stlr
    | stlrb
    | stlrh
    | STLXP stlxp_body { val[1].apply(@asm, val[0]) }
    | STLXR stlxr_body { val[1].apply(@asm, val[0]) }
    | STLXRB wd_wd_read_reg { val[1].apply(@asm, val[0]) }
    | STLXRH wd_wd_read_reg { val[1].apply(@asm, val[0]) }
    | stnp
    | stp
    | str
    | strb
    | strh
    | sttr
    | sttrb
    | sttrh
    | stur
    | stxp
    | stxr
    | stxrb
    | stxrh
    | SUB add_body { val[1].apply(@asm, :sub) }
    | SUBS add_body { val[1].apply(@asm, :subs) }
    | SVC imm { @asm.svc val[1] }
    | SXTB sxtb_body { val[1].apply(@asm, :sxtb) }
    | SXTH sxtb_body { val[1].apply(@asm, :sxth) }
    | SXTW xd_wd { val[1].apply(@asm, :sxtw) }
    | sys
    | sysl
    | TBZ reg_imm_imm_or_label { val[1].apply(@asm, val[0]) }
    | TBNZ reg_imm_imm_or_label { val[1].apply(@asm, val[0]) }
    | tlbi
    | tst
    | UBFIZ ubfiz_body { val[1].apply(@asm, val[0]) }
    | UBFX ubfiz_body { val[1].apply(@asm, val[0]) }
    | UDIV reg_reg_reg { val[1].apply(@asm, val[0]) }
    | UMADDL xd_wd_wd_xd { val[1].apply(@asm, val[0]) }
    | UMNEGL xd_wd_wd { val[1].apply(@asm, val[0]) }
    | UMSUBL xd_wd_wd_xd { val[1].apply(@asm, val[0]) }
    | UMULH xd_xd_xd { val[1].apply(@asm, val[0]) }
    | UMULL xd_wd_wd { val[1].apply(@asm, val[0]) }
    | UXTB wd_wd { val[1].apply(@asm, val[0]) }
    | UXTH wd_wd { val[1].apply(@asm, val[0]) }
    | WFE { @asm.wfe }
    | WFI { @asm.wfi }
    | YIELD { @asm.yield }
    | LABEL_CREATE { register_label(val[0]) }
    ;

  adc
    : ADC reg_reg_reg { val[1].apply(@asm, val[0]) }
    ;

  adcs
    : ADCS reg_reg_reg { val[1].apply(@asm, val[0]) }
    ;

  add_immediate
    : WSP COMMA Wd COMMA imm COMMA LSL imm {
        result = [[val[0], val[2], val[4]], { lsl: val[7] }]
      }
    | Wd COMMA Wd COMMA imm COMMA LSL imm {
        result = [[val[0], val[2], val[4]], { lsl: val[7] }]
      }
    | Xd COMMA Xd COMMA imm COMMA LSL imm {
        result = [[val[0], val[2], val[4]], { lsl: val[7] }]
      }
    | Xd COMMA SP COMMA imm COMMA LSL imm {
        result = [[val[0], val[2], val[4]], { lsl: val[7] }]
      }
    | SP COMMA SP COMMA imm COMMA LSL imm {
        result = [[val[0], val[2], val[4]], { lsl: val[7] }]
      }
    | SP COMMA SP COMMA imm {
        result = [[val[0], val[2], val[4]], { lsl: val[7] }]
      }
    ;

  add_extended
    : add_extend extend imm {
        result = [val[0], { extend: val[1].to_sym, amount: val[2] }]
      }
    | add_extend extend {
        result = [val[0], { extend: val[1].to_sym, amount: 0 }]
      }
    | add_extend_with_sp COMMA LSL imm {
        result = [val[0], { extend: val[2].to_sym, amount: val[3] }]
      }
    ;

  add_extend
    : add_extend_with_sp COMMA
    | add_extend_without_sp
    ;

  add_extend_with_sp
    : SP COMMA Xd COMMA Wd {
        result = [val[0], val[2], val[4]]
      }
    | SP COMMA Xd COMMA Xd {
        result = [val[0], val[2], val[4]]
      }
    | Xd COMMA SP COMMA Wd {
        result = [val[0], val[2], val[4]]
      }
    | Xd COMMA SP COMMA Xd {
        result = [val[0], val[2], val[4]]
      }
    | WSP COMMA Wd COMMA Wd {
        result = [val[0], val[2], val[4]]
      }
    | Wd COMMA WSP COMMA Wd {
        result = [val[0], val[2], val[4]]
      }
    ;

  add_extend_without_sp
    : Xd COMMA Xd COMMA Wd COMMA {
        result = [val[0], val[2], val[4]]
      }
    | Xd COMMA Xd COMMA Xd COMMA {
        result = [val[0], val[2], val[4]]
      }
    | Wd COMMA Wd COMMA Wd COMMA {
        result = [val[0], val[2], val[4]]
      }
    ;

  add_body
    : shifted { result = val[0] }
    | add_extended {
        regs, opts = *val[0]
        result = ThreeWithExtend.new(*regs, extend: opts[:extend], amount: opts[:amount])
      }
    | add_immediate {
        regs, opts = *val[0]
        result = ThreeWithLsl.new(*regs, lsl: opts[:lsl])
      }
    | reg_reg_imm { result = val[0] }
    ;

  reg_reg_shift
    : Wd COMMA Wd COMMA shift imm {
        result = RegRegShift.new(val[0], val[2], shift: val[4], amount: val[5])
      }
    | Xd COMMA Xd COMMA shift imm {
        result = RegRegShift.new(val[0], val[2], shift: val[4], amount: val[5])
      }
    ;

  reg_reg_reg_shift
    : Wd COMMA Wd COMMA Wd COMMA shift imm {
        result = RegsWithShift.new(val[0], val[2], val[4], shift: val[6], amount: val[7])
      }
    | Xd COMMA Xd COMMA Xd COMMA shift imm {
        result = RegsWithShift.new(val[0], val[2], val[4], shift: val[6], amount: val[7])
      }
    ;

  shifted
    : reg_reg_reg_shift
    | reg_reg_reg
    ;

  and_body
    : reg_reg_imm
    | shifted
    ;

  asr
    : ASR reg_reg_reg { result = val[1] }
    | ASR reg_reg_imm { result = val[1] }
    ;

  at: AT at_op COMMA Xd { @asm.at(val[1].to_sym, val[3]) };

  b
    : B imm_or_label { @asm.b(val[1]) }
    | B DOT cond imm_or_label { @asm.b(val[3], cond: val[2]) }
    ;

  bfi
    : BFI Wd COMMA Wd COMMA imm COMMA imm {
        @asm.bfi(val[1], val[3], val[5], val[7])
      }
    | BFI Xd COMMA Xd COMMA imm COMMA imm {
        @asm.bfi(val[1], val[3], val[5], val[7])
      }
    ;

  bfxil
    : BFXIL Wd COMMA Wd COMMA imm COMMA imm {
        @asm.bfxil(val[1], val[3], val[5], val[7])
      }
    | BFXIL Xd COMMA Xd COMMA imm COMMA imm {
        @asm.bfxil(val[1], val[3], val[5], val[7])
      }
    ;

  bic
    : BIC shifted { val[1].apply(@asm, :bic) } ;

  bics
    : BICS shifted { val[1].apply(@asm, :bics) } ;

  autda
    : AUTDA Xd COMMA Xd { @asm.autda(val[1], val[3]) }
    | AUTDA Xd COMMA SP { @asm.autda(val[1], val[3]) }
    ;

  bl : BL imm_or_label { @asm.bl(val[1]) } ;
  blr : BLR Xd { @asm.blr(val[1]) } ;
  br : BR Xd { @asm.br(val[1]) } ;

  cond_four
    : Wd COMMA imm COMMA imm COMMA cond {
        result = FourArg.new(val[0], val[2], val[4], val[6])
      }
    | Wd COMMA Wd COMMA imm COMMA cond {
        result = FourArg.new(val[0], val[2], val[4], val[6])
      }
    | Xd COMMA imm COMMA imm COMMA cond {
        result = FourArg.new(val[0], val[2], val[4], val[6])
      }
    | Xd COMMA Xd COMMA imm COMMA cond {
        result = FourArg.new(val[0], val[2], val[4], val[6])
      }
    | Wd COMMA Wd COMMA Wd COMMA cond {
        result = FourArg.new(val[0], val[2], val[4], val[6])
      }
    | Xd COMMA Xd COMMA Xd COMMA cond {
        result = FourArg.new(val[0], val[2], val[4], val[6])
      }
    ;

  cond_three
    : Wd COMMA Wd COMMA cond { result = ThreeArg.new(val[0], val[2], val[4]) }
    | Xd COMMA Xd COMMA cond { result = ThreeArg.new(val[0], val[2], val[4]) }
    ;

  cond_two
    : Wd COMMA cond { result = TwoArg.new(val[0], val[2]) }
    | Xd COMMA cond { result = TwoArg.new(val[0], val[2]) }

  cinc : CINC cond_three { val[1].apply(@asm, :cinc) };
  cinv : CINV cond_three { val[1].apply(@asm, :cinv) };

  clrex
    : CLREX { @asm.clrex(15) }
    | CLREX imm { @asm.clrex(val[1]) }
    ;

  cmn_immediate
    : SP COMMA imm COMMA LSL imm {
        result = TwoWithLsl.new(val[0], val[2], lsl: val[5])
      }
    | WSP COMMA imm COMMA LSL imm {
        result = TwoWithLsl.new(val[0], val[2], lsl: val[5])
      }
    | Wd COMMA imm COMMA LSL imm {
        result = TwoWithLsl.new(val[0], val[2], lsl: val[5])
      }
    | Xd COMMA imm COMMA LSL imm {
        result = TwoWithLsl.new(val[0], val[2], lsl: val[5])
      }
    | WSP COMMA imm {
        result = TwoArg.new(val[0], val[2])
      }
    | Xd COMMA imm {
        result = TwoArg.new(val[0], val[2])
      }
    | Wd COMMA imm {
        result = TwoArg.new(val[0], val[2])
      }
    | SP COMMA imm {
        result = TwoArg.new(val[0], val[2])
      }
    ;

  cmn_extend_with_sp
    : SP COMMA Wd { result = [val[0], val[2]] }
    | SP COMMA Xd { result = [val[0], val[2]] }
    | WSP COMMA Wd { result = [val[0], val[2]] }
    ;

  cmn_extend_without_sp
    : Wd COMMA Wd COMMA { result = [val[0], val[2]] }
    | Xd COMMA Xd COMMA { result = [val[0], val[2]] }
    | Xd COMMA Wd COMMA { result = [val[0], val[2]] }
    ;

  cmn_extended
    : cmn_extend_with_sp COMMA extend {
        result = TwoWithExtend.new(*val[0], extend: val[2].to_sym, amount: 0)
      }
    | cmn_extend_with_sp COMMA extend imm {
        result = TwoWithExtend.new(*val[0], extend: val[2].to_sym, amount: val[3])
      }
    | cmn_extend_with_sp COMMA LSL imm {
        result = TwoWithExtend.new(*val[0], extend: :lsl, amount: val[3])
      }
    | cmn_extend_with_sp {
        result = TwoWithExtend.new(*val[0], extend: nil, amount: 0)
      }
    | cmn_extend_without_sp extend {
        result = TwoWithExtend.new(*val[0], extend: val[1].to_sym, amount: 0)
      }
    | cmn_extend_without_sp extend imm {
        result = TwoWithExtend.new(*val[0], extend: val[1].to_sym, amount: val[2])
      }
    ;

  cmn_shift
    : Wd COMMA Wd { result = TwoWithShift.new(val[0], val[2], shift: :lsl, amount: 0) }
    | Xd COMMA Xd { result = TwoWithShift.new(val[0], val[2], shift: :lsl, amount: 0) }
    | Wd COMMA Wd COMMA shift imm {
        result = TwoWithShift.new(val[0], val[2], shift: val[4], amount: val[5])
      }
    | Xd COMMA Xd COMMA shift imm {
        result = TwoWithShift.new(val[0], val[2], shift: val[4], amount: val[5])
      }
    ;

  cmn_body
    : cmn_shift
    | cmn_immediate
    | cmn_extended
    ;

  cmn : CMN cmn_body { val[1].apply(@asm, :cmn) }

  cmp : CMP cmn_body { val[1].apply(@asm, :cmp) }

  cneg : CNEG cond_three { val[1].apply(@asm, :cneg) } ;

  crc32w_insns
    : CRC32B
    | CRC32H
    | CRC32W
    ;

  crc32
    : crc32w_insns wd_wd_wd { val[1].apply(@asm, val[0]) }
    | CRC32X wd_wd_xd { val[1].apply(@asm, val[0]) }
    ;

  crc32c_insns
    : CRC32CB
    | CRC32CH
    | CRC32CW
    ;

  crc32c
    : crc32c_insns wd_wd_wd { val[1].apply(@asm, val[0]) }
    | CRC32CX wd_wd_xd { val[1].apply(@asm, val[0]) }
    ;

  cond_four_instructions
    : CSINV
    | CSINC
    | CSEL
    | CCMN
    | CCMP
    | CSNEG
    ;

  cond_fours
    : cond_four_instructions cond_four {
        val[1].apply(@asm, val[0].downcase.to_sym)
      }
    ;

  cset : CSET cond_two { val[1].apply(@asm, :cset) } ;

  csetm : CSETM cond_two { val[1].apply(@asm, :csetm) } ;

  dc
    : DC dc_op COMMA xt { @asm.dc(val[1], val[3]) }
    ;

  dmb
    : DMB imm { @asm.dmb(val[1]) }
    | DMB dmb_option { @asm.dmb(val[1]) }
    ;

  dsb
    : DSB imm { @asm.dsb(val[1]) }
    | DSB dmb_option { @asm.dsb(val[1]) }
    ;

  eor
    : EOR reg_reg_imm { val[1].apply(@asm, :eor) }
    | EOR reg_reg_reg { val[1].apply(@asm, val[0]) }
    | EOR reg_reg_reg_shift { val[1].apply(@asm, val[0]) }
    ;

  eon
    : EON reg_reg_reg { val[1].apply(@asm, val[0]) }
    | EON reg_reg_reg_shift { val[1].apply(@asm, val[0]) }
    ;

  extr : EXTR reg_reg_reg_imm { val[1].apply(@asm, :extr) } ;

  ic
    : IC ic_op { @asm.ic(val[1]) }
    | IC ic_op COMMA xt { @asm.ic(val[1], val[3]) }
    ;

  isb
    : ISB { @asm.isb }
    | ISB imm { @asm.isb(val[1]) }
    ;

  loads
    : ldaxp
    | ldnp
    | ldp
    | ldpsw
    | ldr
    | ldtr
    | ldxp
    | ldxr
    | ldxrb
    | ldxrh
    | w_loads
    | x_loads
    ;

  load_to_w
    : Wd COMMA read_reg RSQ { result = TwoArg.new(val[0], [val[2]]) }
    ;

  load_to_x
    : Xd COMMA read_reg RSQ { result = TwoArg.new(val[0], [val[2]]) }
    ;

  w_load_insns
    : LDARB
    | LDARH
    | LDAR
    | LDAXR
    | LDAXRB
    | LDAXRH
    ;

  w_loads
    : w_load_insns load_to_w { val[1].apply(@asm, val[0].to_sym) }
    ;

  x_load_insns
    : LDAR
    | LDAXR
    ;

  x_loads
    : x_load_insns load_to_x { val[1].apply(@asm, val[0].to_sym) }
    ;

  read_reg
    : LSQ Xd { result = val[1] }
    | LSQ SP { result = val[1] }
    ;

  read_reg_imm
    : read_reg COMMA imm { result = [val[0], val[2]] }
    ;

  w_w_load
    : Wd COMMA Wd COMMA read_reg { result = val.values_at(0, 2, 4) }
    ;

  x_x_load
    : Xd COMMA Xd COMMA read_reg { result = val.values_at(0, 2, 4) }
    ;

  reg_reg_load
    : x_x_load RSQ {
        reg, reg1, l = *val[0]
        result = ThreeArg.new(reg, reg1, [l])
      }
    | w_w_load RSQ {
        reg, reg1, l = *val[0]
        result = ThreeArg.new(reg, reg1, [l])
      }
    ;

  ldaxp
    : LDAXP reg_reg_load { val[1].apply(@asm, val[0].to_sym) }
    ;

  reg_reg_load_offset
    : w_w_load COMMA imm RSQ {
        reg1, reg2, reg3 = *val[0]
        result = ThreeArg.new(reg1, reg2, [reg3, val[2]])
      }
    | x_x_load COMMA imm RSQ {
        reg1, reg2, reg3 = *val[0]
        result = ThreeArg.new(reg1, reg2, [reg3, val[2]])
      }
    | w_w_load RSQ { result = ThreeArg.new(*val[0].first(2), [val[0].last]) }
    | x_x_load RSQ { result = ThreeArg.new(*val[0].first(2), [val[0].last]) }
    ;

  ldnp
    : LDNP reg_reg_load_offset { val[1].apply(@asm, val[0].to_sym) }
    ;

  ldp
    : LDP ldp_body { val[1].apply(@asm, val[0].to_sym) }
    ;

  ldpsw
    : LDPSW ldp_body { val[1].apply(@asm, val[0].to_sym) }
    ;

  ldp_body
    : ldp_signed_offset { result = ThreeArg.new(*val[0]) }
    | ldp_signed_offset BANG { result = FourArg.new(*val[0], :!) }
    | reg_reg_load COMMA imm {
        rt1, rt2, rn = *val[0].to_a
        result = FourArg.new(rt1, rt2, rn, val[2])
      }
    | reg_reg_load {
        rt1, rt2, rn = *val[0].to_a
        result = ThreeArg.new(rt1, rt2, rn)
      }
    ;

  ldp_signed_offset
    : Wd COMMA Wd COMMA read_reg_imm RSQ {
        result = [val[0], val[2], val[4]]
      }
    | Xd COMMA Xd COMMA read_reg_imm RSQ {
        result = [val[0], val[2], val[4]]
      }
    ;

  read_reg_reg
    : read_reg COMMA Xd { result = [val[0], val[2]] }
    | read_reg COMMA Wd { result = [val[0], val[2]] }
    ;

  read_reg_reg_extend_amount
    : read_reg_reg COMMA ldr_extend imm {
        result = [val[0], Shifts::Shift.new(val[3], 0, val[2].to_sym)].flatten
      }
    | read_reg_reg COMMA ldr_extend {
        result = [val[0], Shifts::Shift.new(nil, 0, val[2].to_sym)].flatten
      }
    ;

  ldr_32
    : Wd COMMA read_reg_reg_extend_amount RSQ { result = TwoArg.new(val[0], val[2]) }
    | Wd COMMA read_reg_imm RSQ { result = TwoArg.new(val[0], val[2]) }
    | Wd COMMA read_reg_imm RSQ BANG { result = ThreeArg.new(val[0], val[2], :!) }
    | Wd COMMA read_reg RSQ COMMA imm { result = ThreeArg.new(val[0], [val[2]], val[5]) }
    | Wd COMMA read_reg RSQ { result = TwoArg.new(val[0], [val[2]]) }
    | Wd COMMA read_reg_reg RSQ { result = TwoArg.new(val[0], val[2]) }
    | Wd COMMA imm { result = TwoArg.new(val[0], val[2]) }
    ;

  ldr_64
    : Xd COMMA read_reg_reg_extend_amount RSQ { result = TwoArg.new(val[0], val[2]) }
    | Xd COMMA read_reg_imm RSQ { result = TwoArg.new(val[0], val[2]) }
    | Xd COMMA read_reg_imm RSQ BANG { result = ThreeArg.new(val[0], val[2], :!) }
    | Xd COMMA read_reg RSQ COMMA imm { result = ThreeArg.new(val[0], [val[2]], val[5]) }
    | Xd COMMA read_reg RSQ { result = TwoArg.new(val[0], [val[2]]) }
    | Xd COMMA read_reg_reg RSQ { result = TwoArg.new(val[0], val[2]) }
    | Xd COMMA imm { result = TwoArg.new(val[0], val[2]) }
    ;

  ldr_64s
    : LDR
    | LDRSB
    | LDRSH
    | LDRSW
    ;

  ldr_32s
    : LDR
    | LDRSB
    | LDRB
    | LDRH
    | LDRSH
    ;

  ldr
    : ldr_32s ldr_32 { val[1].apply(@asm, val[0]) }
    | ldr_64s ldr_64 { val[1].apply(@asm, val[0]) }
    ;

  ldtr_32
    : Wd COMMA read_reg_imm RSQ { result = TwoArg.new(val[0], val[2]) }
    | Wd COMMA read_reg RSQ { result = TwoArg.new(val[0], [val[2]]) }
    ;

  ldtr_64
    : Xd COMMA read_reg_imm RSQ { result = TwoArg.new(val[0], val[2]) }
    | Xd COMMA read_reg RSQ { result = TwoArg.new(val[0], [val[2]]) }
    ;

  ldtr_32s
    : LDTR
    | LDTRB
    | LDTRH
    | LDTRSB
    | LDTRSH
    | LDUR
    | LDURB
    | LDURSB
    | LDURSH
    | LDURH
    ;

  ldtr_64s
    : LDTR
    | LDTRSB
    | LDTRSH
    | LDTRSW
    | LDUR
    | LDURSB
    | LDURSH
    | LDURSW
    ;

  ldtr
    : ldtr_32s ldtr_32 { val[1].apply(@asm, val[0]) }
    | ldtr_64s ldtr_64 { val[1].apply(@asm, val[0]) }
    ;

  ldxp
    : LDXP Wd COMMA Wd COMMA read_reg RSQ { @asm.ldxp(val[1], val[3], [val[5]]) }
    | LDXP Xd COMMA Xd COMMA read_reg RSQ { @asm.ldxp(val[1], val[3], [val[5]]) }
    ;

  ldxr
    : LDXR Wd COMMA read_reg RSQ { @asm.ldxr(val[1], [val[3]]) }
    | LDXR Xd COMMA read_reg RSQ { @asm.ldxr(val[1], [val[3]]) }
    ;

  ldxrb
    : LDXRB Wd COMMA read_reg RSQ { @asm.ldxrb(val[1], [val[3]]) }
    ;

  ldxrh
    : LDXRH Wd COMMA read_reg RSQ { @asm.ldxrh(val[1], [val[3]]) }
    ;

  lsl
    : LSL reg_reg_reg { val[1].apply(@asm, val[0]) }
    | LSL reg_reg_imm { val[1].apply(@asm, val[0]) }
    ;

  lsr
    : LSR reg_reg_reg { val[1].apply(@asm, val[0]) }
    | LSR reg_reg_imm { val[1].apply(@asm, val[0]) }
    ;

  mov_sp
    : Xd COMMA SP  { result = TwoArg.new(val[0], val[2]) }
    | SP COMMA Xd  { result = TwoArg.new(val[0], val[2]) }
    | Wd COMMA WSP { result = TwoArg.new(val[0], val[2]) }
    | WSP COMMA Wd { result = TwoArg.new(val[0], val[2]) }
    ;

  mov
    : MOV mov_sp { val[1].apply(@asm, val[0]) }
    | MOV reg_reg { val[1].apply(@asm, val[0]) }
    | MOV reg_imm { val[1].apply(@asm, val[0]) }
    ;

  movz_body
    : register COMMA imm { result = TwoArg.new(val[0], val[2]) }
    | register COMMA imm COMMA LSL imm {
        result = TwoWithLsl.new(val[0], val[2], lsl: val[5])
      }
    ;

  msr
    : MSR SYSTEMREG COMMA Xd {
        TwoArg.new(val[1], val[3]).apply(@asm, val[0])
      }
    ;

  mrs
    : MRS Xd COMMA SYSTEMREG {
        TwoArg.new(val[1], val[3]).apply(@asm, val[0])
      }
    ;

  mvn
    : MVN reg_reg_shift { val[1].apply(@asm, val[0]) }
    | MVN reg_reg { val[1].apply(@asm, val[0]) }
    ;

  neg
    : NEG reg_reg_shift { val[1].apply(@asm, val[0]) }
    | NEG reg_reg { val[1].apply(@asm, val[0]) }
    ;

  negs
    : NEGS reg_reg_shift { val[1].apply(@asm, val[0]) }
    | NEGS reg_reg { val[1].apply(@asm, val[0]) }
    ;

  orn
    : ORN reg_reg_reg { val[1].apply(@asm, val[0]) }
    | ORN reg_reg_reg_shift { val[1].apply(@asm, val[0]) }
    ;

  orr
    : ORR reg_reg_imm { val[1].apply(@asm, val[0]) }
    | ORR reg_reg_reg_shift { val[1].apply(@asm, val[0]) }
    | ORR reg_reg_reg { val[1].apply(@asm, val[0]) }
    ;

  prfm_register
    : PRFOP COMMA read_reg_reg_extend_amount RSQ {
        result = TwoArg.new(val[0].to_sym, val[2])
      }
    ;

  prfm_imm
    : PRFOP COMMA read_reg_imm RSQ {
        result = TwoArg.new(val[0].to_sym, val[2])
      }
    | PRFOP COMMA read_reg RSQ {
        result = TwoArg.new(val[0].to_sym, [val[2]])
      }
    | PRFOP COMMA imm {
        result = TwoArg.new(val[0].to_sym, val[2])
      }
    ;

  prfm
    : PRFM prfm_register { val[1].apply(@asm, val[0]) }
    | PRFM prfm_imm { val[1].apply(@asm, val[0]) }
    | PRFM imm COMMA read_reg_imm RSQ { TwoArg.new(val[1], val[3]).apply(@asm, val[0]) }
    ;

  prfum
    : PRFUM prfm_imm { val[1].apply(@asm, val[0]) }
    ;

  ret
    : RET { @asm.ret }
    | RET Xd { @asm.ret(val[1]) }
    ;

  ror
    : ROR reg_reg_reg { val[1].apply(@asm, val[0]) }
    | ROR reg_reg_imm { val[1].apply(@asm, val[0]) }
    ;

  stlr
    : STLR Wd COMMA read_reg RSQ { @asm.stlr(val[1], [val[3]]) }
    | STLR Xd COMMA read_reg RSQ { @asm.stlr(val[1], [val[3]]) }
    ;

  stlrb
    : STLRB Wd COMMA read_reg RSQ { @asm.stlrb(val[1], [val[3]]) }
    ;

  stlrh
    : STLRH Wd COMMA read_reg RSQ { @asm.stlrh(val[1], [val[3]]) }
    ;

  smaddl_params
    : Xd COMMA Wd COMMA Wd COMMA Xd {
        result = FourArg.new(*val.values_at(0, 2, 4, 6))
      }
    ;

  stlxp_body
    : Wd COMMA Xd COMMA Xd COMMA read_reg RSQ {
        wd, xd1, xd2, r = *val.values_at(0, 2, 4, 6)
        result = FourArg.new(wd, xd1, xd2, [r])
      }
    | Wd COMMA Wd COMMA Wd COMMA read_reg RSQ {
        wd, wd1, wd2, r = *val.values_at(0, 2, 4, 6)
        result = FourArg.new(wd, wd1, wd2, [r])
      }
    ;

  stlxr_body
    : wd_wd_read_reg
    | Wd COMMA Xd COMMA read_reg RSQ {
        wd, xd, rd = *val.values_at(0, 2, 4)
        result = ThreeArg.new(wd, xd, [rd])
      }
    ;

  stnp
    : STNP reg_reg_read_reg_imm RSQ {
        val[1].apply(@asm, val[0])
      }
    ;

  stp
    : STP reg_reg_read_reg_imm RSQ { val[1].apply(@asm, val[0]) }
    | STP reg_reg_read_reg_imm RSQ BANG {
        FourArg.new(*val[1].to_a, :!).apply(@asm, val[0])
      }
    | STP reg_reg_read_reg RSQ COMMA imm {
        rt, rt2, rn = *val[1].to_a
        FourArg.new(rt, rt2, [rn], val[4]).apply(@asm, val[0])
      }
    | STP reg_reg_read_reg RSQ {
        a, b, c = *val[1].to_a
        ThreeArg.new(a, b, [c]).apply(@asm, val[0])
      }
    ;

  str_body
    : register COMMA read_reg_reg_extend_amount RSQ {
        result = TwoArg.new(val[0], val[2])
      }
    | register COMMA read_reg_imm RSQ {
        result = TwoArg.new(val[0], val[2])
      }
    | register COMMA read_reg_imm RSQ BANG {
        result = ThreeArg.new(val[0], val[2], :!)
      }
    | register COMMA read_reg RSQ COMMA imm {
        result = ThreeArg.new(val[0], [val[2]], val[5])
      }
    | register COMMA read_reg RSQ {
        result = TwoArg.new(val[0], [val[2]])
      }
    | register COMMA read_reg_reg RSQ {
        result = TwoArg.new(val[0], val[2])
      }
    ;

  str
    : STR str_body { val[1].apply(@asm, val[0]) }
    ;

  strb_body
    : Wd COMMA read_reg_reg_extend_amount RSQ {
        result = TwoArg.new(val[0], val[2])
      }
    | Wd COMMA read_reg_reg RSQ {
        result = TwoArg.new(val[0], val[2])
      }
    | Wd COMMA read_reg_imm RSQ {
        result = TwoArg.new(val[0], val[2])
      }
    | Wd COMMA read_reg_imm RSQ BANG {
        result = ThreeArg.new(val[0], val[2], :!)
      }
    | Wd COMMA read_reg_imm RSQ COMMA imm {
        result = ThreeArg.new(val[0], val[2], val[5])
      }
    | Wd COMMA read_reg RSQ {
        result = TwoArg.new(val[0], [val[2]])
      }
    | Wd COMMA read_reg RSQ COMMA imm {
        result = ThreeArg.new(val[0], [val[2]], val[5])
      }
    ;

  strb
    : STRB strb_body { val[1].apply(@asm, val[0]) }
    ;

  strh
    : STRH strb_body { val[1].apply(@asm, val[0]) }
    ;

  strr_32
    : Wd COMMA read_reg RSQ { result = TwoArg.new(val[0], [val[2]]) }
    | Wd COMMA read_reg_imm RSQ { result = TwoArg.new(val[0], val[2]) }
    ;

  strr_64
    : Xd COMMA read_reg RSQ { result = TwoArg.new(val[0], [val[2]]) }
    | Xd COMMA read_reg_imm RSQ { result = TwoArg.new(val[0], val[2]) }
    ;

  sttr
    : STTR strr_32 { val[1].apply(@asm, val[0]) }
    | STTR strr_64 { val[1].apply(@asm, val[0]) }
    ;

  sttrb : STTRB strr_32 { val[1].apply(@asm, val[0]) };

  sttrh : STTRH strr_32 { val[1].apply(@asm, val[0]) };

  stur
    : STUR strr_32 { val[1].apply(@asm, val[0]) }
    | STUR strr_64 { val[1].apply(@asm, val[0]) }
    | STURH strr_32 { val[1].apply(@asm, val[0]) }
    | STURB strr_32 { val[1].apply(@asm, val[0]) }
    ;

  stxp
    : STXP wd_wd_wd COMMA read_reg RSQ {
        FourArg.new(*val[1].to_a, [val[3]]).apply(@asm, val[0])
      }
    | STXP wd_xd_xd COMMA read_reg RSQ {
        FourArg.new(*val[1].to_a, [val[3]]).apply(@asm, val[0])
      }
    ;

  stxr
    : STXR wd_wd COMMA read_reg RSQ {
        ThreeArg.new(*val[1].to_a, [val[3]]).apply(@asm, val[0])
      }
    | STXR wd_xd COMMA read_reg RSQ {
        ThreeArg.new(*val[1].to_a, [val[3]]).apply(@asm, val[0])
      }
    ;

  stxrb
    : STXRB wd_wd COMMA read_reg RSQ {
        ThreeArg.new(*val[1].to_a, [val[3]]).apply(@asm, val[0])
      }
    ;

  stxrh
    : STXRH wd_wd COMMA read_reg RSQ {
        ThreeArg.new(*val[1].to_a, [val[3]]).apply(@asm, val[0])
      }
    ;

  sxtb_body
    : wd_wd
    | xd_wd
    ;

  sys
    : SYS imm COMMA Cd COMMA Cd COMMA imm {
        @asm.sys(val[1], val[3], val[5], val[7])
      }
    | SYS imm COMMA Cd COMMA Cd COMMA imm COMMA Xd {
        @asm.sys(val[1], val[3], val[5], val[7], val[9])
      }
    ;
  sysl
    : SYSL Xd COMMA imm COMMA Cd COMMA Cd COMMA imm {
        @asm.sysl(val[1], val[3], val[5], val[7], val[9])
      }
    ;

  reg_imm_imm_or_label
    : Xd COMMA imm COMMA imm_or_label {
        result = ThreeArg.new(val[0], val[2], val[4])
      }
    | Wd COMMA imm COMMA imm_or_label {
        result = ThreeArg.new(val[0], val[2], val[4])
      }
    ;

  tlbi
    : TLBI tlbi_op { @asm.tlbi(val[1].to_sym) }
    | TLBI tlbi_op COMMA Xd { @asm.tlbi(val[1].to_sym, val[3]) }
    ;

  tst
    : TST reg_imm { val[1].apply(@asm, val[0]) }
    | TST reg_reg_shift { val[1].apply(@asm, val[0]) }
    | TST reg_reg { val[1].apply(@asm, val[0]) }
    ;

  ubfiz_body
    : Wd COMMA Wd COMMA imm COMMA imm {
        result = FourArg.new(*val.values_at(0, 2, 4, 6))
      }
    | Xd COMMA Xd COMMA imm COMMA imm {
        result = FourArg.new(*val.values_at(0, 2, 4, 6))
      }
    ;

  xd_wd_wd_xd
    : Xd COMMA Wd COMMA Wd COMMA Xd {
        result = FourArg.new(*val.values_at(0, 2, 4, 6))
      }
    ;

  wd_wd_read_reg
    : Wd COMMA Wd COMMA read_reg RSQ {
        result = ThreeArg.new(val[0], val[2], [val[4]])
      }
    ;

  reg_reg_read_reg
    : Wd COMMA Wd COMMA read_reg {
        result = ThreeArg.new(*val.values_at(0, 2, 4))
      }
    | Xd COMMA Xd COMMA read_reg {
        result = ThreeArg.new(*val.values_at(0, 2, 4))
      }
    ;

  reg_reg_read_reg_imm
    : wd_wd_read_reg_imm
    | xd_xd_read_reg_imm
    ;

  wd_wd_read_reg_imm
    : Wd COMMA Wd COMMA read_reg_imm {
        result = ThreeArg.new(*val.values_at(0, 2, 4))
      }
    ;

  xd_xd_read_reg_imm
    : Xd COMMA Xd COMMA read_reg_imm {
        result = ThreeArg.new(*val.values_at(0, 2, 4))
      }
    ;

  xd_wd_wd
    : Xd COMMA Wd COMMA Wd {
        result = ThreeArg.new(*val.values_at(0, 2, 4))
      }
    ;

  xd_wd
    : Xd COMMA Wd {
        result = TwoArg.new(*val.values_at(0, 2))
      }
    ;

  reg_reg_imm_imm
    : Wd COMMA Wd COMMA imm COMMA imm {
        result = FourArg.new(*val.values_at(0, 2, 4, 6))
      }
    | Xd COMMA Xd COMMA imm COMMA imm {
        result = FourArg.new(*val.values_at(0, 2, 4, 6))
      }
    ;

  shift
    : LSL { result = val[0].to_sym }
    | LSR { result = val[0].to_sym }
    | ASR { result = val[0].to_sym }
    | ROR { result = val[0].to_sym }
    ;

  register
    : Xd
    | Wd
    ;

  xd_xd : Xd COMMA Xd { result = TwoArg.new(val[0], val[2]) };

  reg_reg
    : Wd COMMA Wd { result = TwoArg.new(val[0], val[2]) }
    | xd_xd
    ;

  xd_xd_xd
    : Xd COMMA Xd COMMA Xd { result = ThreeArg.new(val[0], val[2], val[4]) }
    ;

  wd_wd_wd
    : Wd COMMA Wd COMMA Wd { result = ThreeArg.new(val[0], val[2], val[4]) }
    ;

  wd_wd_xd
    : Wd COMMA Wd COMMA Xd { result = ThreeArg.new(val[0], val[2], val[4]) }
    ;

  wd_wd
    : Wd COMMA Wd { result = TwoArg.new(val[0], val[2]) }
    ;

  wd_xd
    : Wd COMMA Xd { result = TwoArg.new(val[0], val[2]) }
    ;

  wd_xd_xd
    : Wd COMMA Xd COMMA Xd { result = ThreeArg.new(val[0], val[2], val[4]) }
    ;

  reg_reg_reg
    : wd_wd_wd
    | xd_xd_xd
    ;

  reg_reg_reg_reg
    : Wd COMMA Wd COMMA Wd COMMA Wd { result = FourArg.new(val[0], val[2], val[4], val[6]) }
    | Xd COMMA Xd COMMA Xd COMMA Xd { result = FourArg.new(val[0], val[2], val[4], val[6]) }
    ;

  reg_imm
    : Wd COMMA imm { result = TwoArg.new(val[0], val[2]) }
    | Xd COMMA imm { result = TwoArg.new(val[0], val[2]) }
    ;

  reg_imm_or_label
    : Wd COMMA imm_or_label { result = TwoArg.new(val[0], val[2]) }
    | Xd COMMA imm_or_label { result = TwoArg.new(val[0], val[2]) }
    ;

  reg_reg_imm
    : Wd COMMA Wd COMMA imm {
        result = ThreeArg.new(val[0], val[2], val[4])
      }
    | Xd COMMA Xd COMMA imm {
        result = ThreeArg.new(val[0], val[2], val[4])
      }
    | Xd COMMA SP COMMA imm {
        result = ThreeArg.new(val[0], val[2], val[4])
      }
    | SP COMMA Xd COMMA imm {
        result = ThreeArg.new(val[0], val[2], val[4])
      }
    | WSP COMMA Wd COMMA imm {
        result = ThreeArg.new(val[0], val[2], val[4])
      }
    | Wd COMMA WSP COMMA imm {
        result = ThreeArg.new(val[0], val[2], val[4])
      }
    | WSP COMMA WSP COMMA imm {
        result = ThreeArg.new(val[0], val[2], val[4])
      }
    ;

  reg_reg_reg_imm
    : Wd COMMA Wd COMMA Wd COMMA imm {
        result = FourArg.new(val[0], val[2], val[4], val[6])
      }
    | Xd COMMA Xd COMMA Xd COMMA imm {
        result = FourArg.new(val[0], val[2], val[4], val[6])
      }
    ;

  imm
    : '#' NUMBER { result = val[1] }
    | NUMBER     { result = val[0] }
    ;

  imm_or_label
    : LABEL { result = label_for(val[0]) }
    | imm
    ;

  xt: Xd | XZR;

  cond : EQ | LO | LT | HS | GT | LE | NE | MI | GE | PL | LS | HI | VC | VS;

  extend
      : UXTB
      | UXTH
      | UXTW
      | UXTX
      | SXTB
      | SXTH
      | SXTW
      | SXTX
      ;

  ldr_extend
      : LSL
      | UXTW
      | SXTW
      | SXTX
      ;

  dc_op
      : IVAC
      | ISW
      | IGVAC
      | IGSW
      | IGDVAC
      | IGDSW
      | CSW
      | CGSW
      | CGDSW
      | CISW
      | CIGSW
      | CIGDSW
      | ZVA
      | GVA
      | GZVA
      | CVAC
      | CGVAC
      | CGDVAC
      | CVAU
      | CVAP
      | CGVAP
      | CGDVAP
      | CVADP
      | CGVADP
      | CGDVADP
      | CIVAC
      | CIGVAC
      | CIGDVAC
      ;
  ic_op
      : IALLUIS
      | IALLU
      | IVAU
      ;

  at_op
      : S1E1R
      | S1E1W
      | S1E0R
      | S1E0W
      | S1E1RP
      | S1E1WP
      | S1E2R
      | S1E2W
      | S12E1R
      | S12E1W
      | S12E0R
      | S12E0W
      | S1E3R
      | S1E3W
      ;

  dmb_option
      : OSHLD
      | OSHST
      | OSH
      | NSHLD
      | NSHST
      | NSH
      | ISHLD
      | ISHST
      | ISH
      | LD
      | ST
      | SY
      ;

  tlbi_op
      : VMALLE1OS
      | VAE1OS
      | ASIDE1OS
      | VAAE1OS
      | VALE1OS
      | VAALE1OS
      | RVAE1IS
      | RVAAE1IS
      | RVALE1IS
      | RVAALE1IS
      | VMALLE1IS
      | VAE1IS
      | ASIDE1IS
      | VAAE1IS
      | VALE1IS
      | VAALE1IS
      | RVAE1OS
      | RVAAE1OS
      | RVALE1OS
      | RVAALE1OS
      | RVAE1
      | RVAAE1
      | RVALE1
      | RVAALE1
      | VMALLE1
      | VAE1
      | ASIDE1
      | VAAE1
      | VALE1
      | VAALE1
      | IPAS2E1IS
      | RIPAS2E1IS
      | IPAS2LE1IS
      | RIPAS2LE1IS
      | ALLE2OS
      | VAE2OS
      | ALLE1OS
      | VALE2OS
      | VMALLS12E1OS
      | RVAE2IS
      | RVALE2IS
      | ALLE2IS
      | VAE2IS
      | ALLE1IS
      | VALE2IS
      | VMALLS12E1IS
      | IPAS2E1OS
      | IPAS2E1
      | RIPAS2E1
      | RIPAS2E1OS
      | IPAS2LE1OS
      | IPAS2LE1
      | RIPAS2LE1
      | RIPAS2LE1OS
      | RVAE2OS
      | RVALE2OS
      | RVAE2
      | RVALE2
      | ALLE2
      | VAE2
      | ALLE1
      | VALE2
      | VMALLS12E1
      | ALLE3OS
      | VAE3OS
      | VALE3OS
      | RVAE3IS
      | RVALE3IS
      | ALLE3IS
      | VAE3IS
      | VALE3IS
      | RVAE3OS
      | RVALE3OS
      | RVAE3
      | RVALE3
      | ALLE3
      | VAE3
      | VALE3
      ;
