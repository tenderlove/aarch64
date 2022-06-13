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
    | add
    | adds
    | ADR Xd COMMA imm { @asm.adr(val[1], val[3]) }
    | ADRP Xd COMMA imm { @asm.adrp(val[1], val[3]) }
    | and { val[0].apply(@asm, :and) }
    | ands { val[0].apply(@asm, :ands) }
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
    | cbnz
    | cbz
    | cinc
    | cinv
    | clrex
    | cls
    | clz
    | cmn
    | cmp
    | cneg
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
    | ERET { @asm.eret }
    | extr
    | ic
    | isb
    | movz
    | cond_fours
    | loads
    | lsl
    | lsr
    | madd
    | mneg
    | mov
    | msub
    | mul
    | neg
    | negs
    | ngc
    | ngcs
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

  add
    : ADD shifted {
        val[1].apply(@asm, :add)
      }
    | ADD add_extended {
        regs, opts = *val[1]
        r1, r2, r3 = *regs
        @asm.add(r1, r2, r3, extend: opts[:extend], amount: opts[:amount])
      }
    | ADD add_immediate {
        regs, opts = *val[1]
        r1, r2, r3 = *regs
        @asm.add(r1, r2, r3, lsl: opts[:lsl])
      }
    | ADD reg_reg_imm { val[1].apply(@asm, val[0]) }
    ;

  adds
    : ADDS shifted {
        val[1].apply(@asm, :adds)
      }
    | ADDS add_extended {
        regs, opts = *val[1]
        r1, r2, r3 = *regs
        @asm.adds(r1, r2, r3, extend: opts[:extend], amount: opts[:amount])
      }
    | ADDS add_immediate {
        regs, opts = *val[1]
        r1, r2, r3 = *regs
        @asm.adds(r1, r2, r3, lsl: opts[:lsl])
      }
    | ADDS reg_reg_imm { val[1].apply(@asm, val[0]) }
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

  and
    : AND reg_reg_imm { result = val[1] }
    | AND shifted { result = val[1] }
    ;

  ands
    : ANDS reg_reg_imm { result = val[1] }
    | ANDS shifted { result = val[1] }
    ;

  asr
    : ASR reg_reg_reg { result = val[1] }
    | ASR reg_reg_imm { result = val[1] }
    ;

  at: AT at_op COMMA Xd { @asm.at(val[1].to_sym, val[3]) };

  b
    : B imm { @asm.b(val[1]) }
    | B DOT cond imm { @asm.b(val[3], cond: val[2]) }
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
    : AUTDA xd COMMA xn { @asm.autda(val[1], val[3]) }
    | AUTDA xd COMMA SP { @asm.autda(val[1], val[3]) }
    ;

  bl : BL imm { @asm.bl(val[1]) } ;
  blr : BLR Xd { @asm.blr(val[1]) } ;
  br : BR Xd { @asm.br(val[1]) } ;

  cbnz
    : CBNZ Wd COMMA imm { @asm.cbnz(val[1], val[3]) }
    | CBNZ Xd COMMA imm { @asm.cbnz(val[1], val[3]) }
    ;

  cbz
    : CBZ Wd COMMA imm { @asm.cbz(val[1], val[3]) }
    | CBZ Xd COMMA imm { @asm.cbz(val[1], val[3]) }
    ;

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

  cls
    : CLS Wd COMMA Wd { @asm.cls(val[1], val[3]) }
    | CLS Xd COMMA Xd { @asm.cls(val[1], val[3]) }
    ;

  clz
    : CLZ Wd COMMA Wd { @asm.clz(val[1], val[3]) }
    | CLZ Xd COMMA Xd { @asm.clz(val[1], val[3]) }
    ;

  cmn_immediate
    : SP COMMA imm COMMA LSL imm {
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

  eor : EOR reg_reg_imm { val[1].apply(@asm, :eor) } ;

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
    : Wd COMMA read_reg RSQ { result = TwoArg.new(val[0], val[2]) }
    ;

  load_to_x
    : Xd COMMA read_reg RSQ { result = TwoArg.new(val[0], val[2]) }
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
    : x_x_load RSQ { result = ThreeArg.new(*val[0]) }
    | w_w_load RSQ { result = ThreeArg.new(*val[0]) }
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
        result = FourArg.new(rt1, rt2, [rn], val[2])
      }
    | reg_reg_load {
        rt1, rt2, rn = *val[0].to_a
        result = ThreeArg.new(rt1, rt2, [rn])
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
    | Wd COMMA read_reg RSQ { result = TwoArg.new(val[0], val[2]) }
    ;

  ldtr_64
    : Xd COMMA read_reg_imm RSQ { result = TwoArg.new(val[0], val[2]) }
    | Xd COMMA read_reg RSQ { result = TwoArg.new(val[0], val[2]) }
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
    : LDXP Wd COMMA Wd COMMA read_reg RSQ { @asm.ldxp(val[1], val[3], val[5]) }
    | LDXP Xd COMMA Xd COMMA read_reg RSQ { @asm.ldxp(val[1], val[3], val[5]) }
    ;

  ldxr
    : LDXR Wd COMMA read_reg RSQ { @asm.ldxr(val[1], val[3]) }
    | LDXR Xd COMMA read_reg RSQ { @asm.ldxr(val[1], val[3]) }
    ;

  ldxrb
    : LDXRB Wd COMMA read_reg RSQ { @asm.ldxrb(val[1], val[3]) }
    ;

  ldxrh
    : LDXRH Wd COMMA read_reg RSQ { @asm.ldxrh(val[1], val[3]) }
    ;

  lsl
    : LSL reg_reg_reg { val[1].apply(@asm, val[0]) }
    | LSL reg_reg_imm { val[1].apply(@asm, val[0]) }
    ;

  lsr
    : LSR reg_reg_reg { val[1].apply(@asm, val[0]) }
    | LSR reg_reg_imm { val[1].apply(@asm, val[0]) }
    ;

  mneg
    : MNEG reg_reg_reg { val[1].apply(@asm, val[0]) }
    ;

  madd
    : MADD reg_reg_reg_reg { val[1].apply(@asm, val[0]) }
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

  movz
    : MOVZ register COMMA imm { @asm.movz(val[1], val[3]) }
    | MOVZ register COMMA imm COMMA LSL imm { @asm.movz(val[1], val[3], lsl: val[6]) }
    ;

  msub
    : MSUB reg_reg_reg_reg { val[1].apply(@asm, val[0]) }
    ;

  mul
    : MUL reg_reg_reg { val[1].apply(@asm, val[0]) }
    ;

  neg
    : NEG reg_reg_shift { val[1].apply(@asm, val[0]) }
    | NEG reg_reg { val[1].apply(@asm, val[0]) }
    ;

  negs
    : NEGS reg_reg_shift { val[1].apply(@asm, val[0]) }
    | NEGS reg_reg { val[1].apply(@asm, val[0]) }
    ;

  ngc
    : NGC reg_reg { val[1].apply(@asm, val[0]) }
    ;

  ngcs
    : NGCS reg_reg { val[1].apply(@asm, val[0]) }
    ;

  orn
    : ORN reg_reg_reg { val[1].apply(@asm, val[0]) }
    | ORN reg_reg_reg_shift { val[1].apply(@asm, val[0]) }
    ;

  orr
    : ORR reg_reg_imm { val[1].apply(@asm, val[0]) }
    | ORR reg_reg_reg_shift { val[1].apply(@asm, val[0]) }
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
    ;

  prfm
    : PRFM prfm_register { val[1].apply(@asm, val[0]) }
    | PRFM prfm_imm { val[1].apply(@asm, val[0]) }
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
    : STLR Wd COMMA read_reg RSQ { @asm.stlr(val[1], val[3]) }
    | STLR Xd COMMA read_reg RSQ { @asm.stlr(val[1], val[3]) }
    ;

  stlrb
    : STLRB Wd COMMA read_reg RSQ { @asm.stlrb(val[1], val[3]) }
    ;

  stlrh
    : STLRH Wd COMMA read_reg RSQ { @asm.stlrh(val[1], val[3]) }
    ;

  smaddl_params
    : Xd COMMA Wd COMMA Wd COMMA Xd {
        result = FourArg.new(*val.values_at(0, 2, 4, 6))
      }
    ;

  stlxp_body
    : Wd COMMA Xd COMMA Xd COMMA read_reg RSQ {
        result = FourArg.new(*val.values_at(0, 2, 4, 6))
      }
    | Wd COMMA Wd COMMA Wd COMMA read_reg RSQ {
        result = FourArg.new(*val.values_at(0, 2, 4, 6))
      }
    ;

  stlxr_body
    : wd_wd_read_reg
    | Wd COMMA Xd COMMA read_reg RSQ {
        result = ThreeArg.new(*val.values_at(0, 2, 4))
      }
    ;

  stnp
    : STNP wd_wd_read_reg_imm RSQ {
        val[1].apply(@asm, val[0])
      }
    ;

  stp
    : STP reg_reg_read_reg_imm RSQ { val[1].apply(@asm, val[0]) }
    | STP reg_reg_read_reg_imm RSQ BANG {
        FourArg.new(*val[1].to_a, :!).apply(@asm, val[0])
      }
    | STP reg_reg_read_reg RSQ COMMA imm {
        FourArg.new(*val[1].to_a, val[4]).apply(@asm, val[0])
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
        result = ThreeArg.new(val[0], val[2], val[5])
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
        result = ThreeArg.new(val[0], val[2], val[5])
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
        FourArg.new(*val[1].to_a, val[3]).apply(@asm, val[0])
      }
    | STXP wd_xd_xd COMMA read_reg RSQ {
        FourArg.new(*val[1].to_a, val[3]).apply(@asm, val[0])
      }
    ;

  wd_wd_read_reg
    : Wd COMMA Wd COMMA read_reg RSQ {
        result = ThreeArg.new(*val.values_at(0, 2, 4))
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

  xd: Xd;
  xn: Xd;
  xt: Xd | XZR;

  cond : EQ | LO | LT | HS | GT | LE | NE | MI | GE | PL;

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
