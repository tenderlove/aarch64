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
    | dc
    | ic
    | movz
    ;

  adc
    : ADC wd COMMA wd COMMA wd { @asm.adc(val[1], val[3], val[5]) }
    | ADC xt COMMA xt COMMA xt { @asm.adc(val[1], val[3], val[5]) }
    ;

  adcs
    : ADCS wd COMMA wd COMMA wd { @asm.adcs(val[1], val[3], val[5]) }
    | ADCS xt COMMA xt COMMA xt { @asm.adcs(val[1], val[3], val[5]) }
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
    | Wd COMMA WSP COMMA imm {
        result = [[val[0], val[2], val[4]], { lsl: 0 }]
      }
    | WSP COMMA Wd COMMA imm {
        result = [[val[0], val[2], val[4]], { lsl: 0 }]
      }
    | WSP COMMA WSP COMMA imm {
        result = [[val[0], val[2], val[4]], { lsl: 0 }]
      }
    | Wd COMMA Wd COMMA imm {
        result = [[val[0], val[2], val[4]], { lsl: 0 }]
      }
    | Xd COMMA SP COMMA imm {
        result = [[val[0], val[2], val[4]], { lsl: 0 }]
      }
    | SP COMMA Xd COMMA imm {
        result = [[val[0], val[2], val[4]], { lsl: 0 }]
      }
    | Xd COMMA Xd COMMA imm {
        result = [[val[0], val[2], val[4]], { lsl: 0 }]
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
    ;

  and_immediate
    : Wd COMMA Wd COMMA imm {
        result = RegsWithShift.new(val[0], val[2], val[4])
      }
    | Xd COMMA Xd COMMA imm {
        result = RegsWithShift.new(val[0], val[2], val[4])
      }
    ;

  shifted
    : Wd COMMA Wd COMMA Wd COMMA shift imm {
        result = RegsWithShift.new(val[0], val[2], val[4], shift: val[6], amount: val[7])
      }
    | Xd COMMA Xd COMMA Xd COMMA shift imm {
        result = RegsWithShift.new(val[0], val[2], val[4], shift: val[6], amount: val[7])
      }
    | Wd COMMA Wd COMMA Wd {
        result = RegsWithShift.new(val[0], val[2], val[4])
      }
    | Xd COMMA Xd COMMA Xd {
        result = RegsWithShift.new(val[0], val[2], val[4])
      }
    ;

  and
    : AND and_immediate { result = val[1] }
    | AND shifted { result = val[1] }
    ;

  ands
    : ANDS and_immediate { result = val[1] }
    | ANDS shifted { result = val[1] }
    ;

  asr
    : ASR three_regs { result = val[1] }
    | ASR Wd COMMA Wd COMMA imm {
        result = ThreeRegs.new(val[1], val[3], val[5])
      }
    | ASR Xd COMMA Xd COMMA imm {
        result = ThreeRegs.new(val[1], val[3], val[5])
      }
    ;

  at: AT at_op COMMA Xd { @asm.at(val[1].to_sym, val[3]) };

  b
    : B imm { @asm.b(val[1]) }
    | B DOT cond imm { @asm.b(val[3], cond: val[2]) }
    ;

  cond
    : EQ
    | LO
    | LT
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

  three_regs
    : Wd COMMA Wd COMMA Wd { result = ThreeRegs.new(val[0], val[2], val[4]) }
    | Xd COMMA Xd COMMA Xd { result = ThreeRegs.new(val[0], val[2], val[4]) }
    ;

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

  dc
    : DC dc_op COMMA xt { @asm.dc(val[1], val[3]) }
    ;

  ic
    : IC ic_op { @asm.ic(val[1]) }
    | IC ic_op COMMA xt { @asm.ic(val[1], val[3]) }
    ;

  movz
    : MOVZ register COMMA imm { @asm.movz(val[1], val[3]) }
    | MOVZ register COMMA imm COMMA LSL imm { @asm.movz(val[1], val[3], lsl: val[6]) }
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

  imm
    : '#' NUMBER { result = val[1] }
    | NUMBER     { result = val[0] }
    ;

  xd: Xd;
  xn: Xd;
  xt: Xd | XZR;
  wd: Wd | WZR;

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
