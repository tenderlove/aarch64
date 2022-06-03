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
    | autda
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
        @asm.add(val[0], val[2], val[4], lsl: val[7])
      }
    | Wd COMMA Wd COMMA imm COMMA LSL imm {
        @asm.add(val[0], val[2], val[4], lsl: val[7])
      }
    | Xd COMMA Xd COMMA imm COMMA LSL imm {
        @asm.add(val[0], val[2], val[4], lsl: val[7])
      }
    | Wd COMMA WSP COMMA imm {
        @asm.add(val[0], val[2], val[4])
      }
    | WSP COMMA Wd COMMA imm {
        @asm.add(val[0], val[2], val[4])
      }
    | WSP COMMA WSP COMMA imm {
        @asm.add(val[0], val[2], val[4])
      }
    | Wd COMMA Wd COMMA imm {
        @asm.add(val[0], val[2], val[4])
      }
    | Xd COMMA SP COMMA imm {
        @asm.add(val[0], val[2], val[4])
      }
    | SP COMMA Xd COMMA imm {
        @asm.add(val[0], val[2], val[4])
      }
    | Xd COMMA Xd COMMA imm {
        @asm.add(val[0], val[2], val[4])
      }
    ;

  add_shifted
    : Wd COMMA Wd COMMA Wd COMMA shift imm {
        @asm.add(val[0], val[2], val[4], shift: val[6].to_sym, amount: val[7])
      }
    | Xd COMMA Xd COMMA Xd COMMA shift imm {
        @asm.add(val[0], val[2], val[4], shift: val[6].to_sym, amount: val[7])
      }
    | Wd COMMA Wd COMMA Wd {
        @asm.add(val[0], val[2], val[4])
      }
    | Xd COMMA Xd COMMA Xd {
        @asm.add(val[0], val[2], val[4])
      }
    ;

  add_extended
    : add_extend extend imm {
        @asm.add(*val[0], extend: val[1].to_sym, amount: val[2])
      }
    | add_extend extend {
        @asm.add(*val[0], extend: val[1].to_sym)
      }
    | add_extend_with_sp COMMA LSL imm {
        @asm.add(*val[0], extend: val[2].to_sym, amount: val[3])
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
    : ADD add_shifted
    | ADD add_extended
    | ADD add_immediate
    ;
  autda
    : AUTDA xd COMMA xn { @asm.autda(val[1], val[3]) }
    | AUTDA xd COMMA SP { @asm.autda(val[1], val[3]) }
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
    : LSL
    | LSR
    | ASR
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
