require "helper"

class BaseInstructionsTest < AArch64::Test
  include AArch64
  include AArch64::Registers
  include AArch64::Conditions
  include AArch64::Extends
  include AArch64::Shifts
  include AArch64::Names
  include AArch64::SystemRegisters

  attr_reader :asm

  def setup
    @asm = Assembler.new
  end

  def test_adc
    asm.adc X0, X1, X2
    assert_one_insn "adc x0, x1, x2"
  end

  def test_adc_w
    asm.adc W0, W1, W2
    assert_one_insn "adc w0, w1, w2"
  end

  def test_adcs
    asm.adcs X0, X1, X2
    assert_one_insn "adcs x0, x1, x2"
  end

  def test_adcs_w
    asm.adcs W0, W1, W2
    assert_one_insn "adcs w0, w1, w2"
  end

  def test_add_extended_register
    asm.add X0, X1, X2, extend: :sxtx
    assert_one_insn "add x0, x1, x2, sxtx"
  end

  def test_add_extended_register_amount
    asm.add X0, X1, X2, extend: :sxtx, amount: 4
    assert_one_insn "add x0, x1, x2, sxtx #4"
  end

  def test_add_extended_register_w
    asm.add X0, X1, W2, extend: :sxtw
    assert_one_insn "add x0, x1, w2, sxtw"
  end

  def test_add_extended_register_www
    asm.add W0, W1, W2, extend: :sxtw
    assert_one_insn "add w0, w1, w2, sxtw"
  end

  def test_add_immediate
    asm.add X0, X1, 0x2a
    assert_one_insn "add x0, x1, #0x2a"
  end

  def test_add_immediate_shift
    asm.add X0, X1, 0x2a, lsl: 12
    assert_one_insn "add x0, x1, #0x2a, lsl #12"
  end

  def test_add_immediate_shift_w
    asm.add W0, W1, 0x2a, lsl: 12
    assert_one_insn "add w0, w1, #0x2a, lsl #12"
  end

  def test_add_addsub_shift
    asm.add X0, X1, X2
    assert_one_insn "add x0, x1, x2"
  end

  def test_add_addsub_shift_amount
    asm.add X0, X1, X2, shift: :lsr, amount: 3
    assert_one_insn "add x0, x1, x2, lsr #3"
  end

  def test_addg
    skip "clang doesn't seem to support this one"
    asm.addg X0, X1, 16, 1
    assert_one_insn "addg x0, x1, #4, #2"
  end

  def test_ADDS_addsub_ext_32
    asm.adds W3, W5, W7, extend: :uxth
    assert_one_insn "adds w3, w5, w7, uxth"
  end

  def test_ADDS_addsub_ext
    asm.adds X3, X5, X9, extend: :sxtx, amount: 2
    assert_one_insn "adds x3, x5, x9, sxtx #2"
  end

  def test_ADDS_addsub_imm
    asm.adds X3, X5, 3
    assert_one_insn "adds x3, x5, #3"
  end

  def test_ADDS_addsub_imm_w
    asm.adds W3, W5, 3
    assert_one_insn "adds w3, w5, #3"
  end

  def test_ADDS_addsub_imm_shift
    asm.adds X3, X5, 3, lsl: 12
    assert_one_insn "adds x3, x5, #3, lsl #12"
  end

  def test_ADDS_addsub_shift
    asm.adds X3, X5, X1
    assert_one_insn "adds x3, x5, x1"
  end

  def test_ADDS_addsub_shift_ok
    asm.adds X3, X5, X1, shift: :lsr
    assert_one_insn "adds x3, x5, x1, lsr #0"
  end

  def test_ADDS_addsub_shift_amount
    asm.adds X3, X5, X1, shift: :lsr, amount: 3
    assert_one_insn "adds x3, x5, x1, lsr #3"
  end

  def test_ADR
    label = asm.make_label :foo
    asm.adr X3, label
    asm.put_label label
    assert_one_insn "adr x3, #4"
  end

  def test_ADRP
    asm.adrp X3, 4000
    assert_one_insn "adrp x3, #0x4000"
  end

  def test_AND_log_imm
    assert_one_insn "and x3, x1, #2" do |asm|
      asm.and X3, X1, 2
    end

    assert_one_insn "and w3, w1, #1" do |asm|
      asm.and W3, W1, 1
    end
  end

  def test_AND_log_shift
    # AND  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    assert_one_insn "and w3, w1, w2" do |asm|
      asm.and W3, W1, W2
    end

    assert_one_insn "and w3, w1, w2, lsr #0" do |asm|
      asm.and W3, W1, W2, shift: :lsr
    end

    assert_one_insn "and w3, w1, w2, lsr #3" do |asm|
      asm.and W3, W1, W2, shift: :lsr, amount: 3
    end

    # AND  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    assert_one_insn "and x3, x1, x2" do |asm|
      asm.and X3, X1, X2
    end

    assert_one_insn "and x3, x1, x2, lsr #0" do |asm|
      asm.and X3, X1, X2, shift: :lsr
    end

    assert_one_insn "and x3, x1, x2, lsr #3" do |asm|
      asm.and X3, X1, X2, shift: :lsr, amount: 3
    end
  end

  def test_ANDS_log_imm
    # ANDS  <Wd>, <Wn>, #<imm>
    assert_one_insn "ands w3, w1, #1" do |asm|
      asm.ands W3, W1, 1
    end

    # ANDS  <Xd>, <Xn>, #<imm>
    assert_one_insn "ands x3, x1, #2" do |asm|
      asm.ands X3, X1, 2
    end
  end

  def test_ANDS_log_shift
    # ANDS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    assert_one_insn "ands w3, w1, w2" do |asm|
      asm.ands W3, W1, W2
    end

    assert_one_insn "ands w3, w1, w2, lsr #0" do |asm|
      asm.ands W3, W1, W2, shift: :lsr
    end

    assert_one_insn "ands w3, w1, w2, lsr #3" do |asm|
      asm.ands W3, W1, W2, shift: :lsr, amount: 3
    end

    # ANDS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    assert_one_insn "ands x3, x1, x2" do |asm|
      asm.ands X3, X1, X2
    end

    assert_one_insn "ands x3, x1, x2, lsr #0" do |asm|
      asm.ands X3, X1, X2, shift: :lsr
    end

    assert_one_insn "ands x3, x1, x2, lsr #3" do |asm|
      asm.ands X3, X1, X2, shift: :lsr, amount: 3
    end
  end

  def test_ASR_SBFM
    # ASR  <Wd>, <Wn>, #<shift>
    assert_one_insn "asr w3, w1, #3" do |asm|
      asm.asr W3, W1, 3
    end

    # SBFM <Wd>, <Wn>, #<shift>, #31
    assert_one_insn "asr w3, w1, #3" do |asm|
      asm.sbfm W3, W1, 3, 31
    end

    # ASR  <Xd>, <Xn>, #<shift>
    assert_one_insn "asr x3, x1, #3" do |asm|
      asm.asr X3, X1, 3
    end

    # SBFM <Xd>, <Xn>, #<shift>, #63
    assert_one_insn "asr x3, x1, #3" do |asm|
      asm.sbfm X3, X1, 3, 63
    end
  end

  def test_ASR_ASRV
    # ASR  <Wd>, <Wn>, <Wm>
    assert_one_insn "asr w3, w1, w2" do |asm|
      asm.asr W3, W1, W2
    end

    # ASRV <Wd>, <Wn>, <Wm>
    assert_one_insn "asr w3, w1, w2" do |asm|
      asm.asrv W3, W1, W2
    end

    # ASR  <Xd>, <Xn>, <Xm>
    assert_one_insn "asr x3, x1, x2" do |asm|
      asm.asr X3, X1, X2
    end

    # ASRV <Xd>, <Xn>, <Xm>
    assert_one_insn "asr x3, x1, x2" do |asm|
      asm.asrv X3, X1, X2
    end
  end

  def test_ASRV
    # ASRV  <Wd>, <Wn>, <Wm>
    assert_one_insn "asr w3, w1, w2" do |asm|
      asm.asrv W3, W1, W2
    end

    # ASRV  <Xd>, <Xn>, <Xm>
    assert_one_insn "asr x3, x1, x2" do |asm|
      asm.asrv X3, X1, X2
    end
  end

  def test_AT_SYS
    # AT  <at_op>, <Xt>
    assert_one_insn "at s1e1r, x1" do |asm|
      asm.at :s1e1r, X1
    end

    # SYS #<op1>, C7, <Cm>, #<op2>, <Xt>
    assert_one_insn "sys #0, c7, c9, #0, x1" do |asm|
      asm.at :s1e1rp, X1
    end
  end

  def test_AUTDA
    # AUTDA  <Xd>, <Xn|SP>
    assert_bytes [0x41, 0x18, 0xc1, 0xda] do |asm|
      asm.autda X1, X2
    end

    # AUTDZA  <Xd>
    assert_bytes [0xe1, 0x3b, 0xc1, 0xda] do |asm|
      asm.autdza X1
    end
  end

  def test_AUTDB
    # AUTDB  <Xd>, <Xn|SP>
    assert_bytes [0x41, 0x1c, 0xc1, 0xda] do |asm|
      asm.autdb X1, X2
    end

    # AUTDZB  <Xd>
    assert_bytes [0xe1, 0x3f, 0xc1, 0xda] do |asm|
      asm.autdzb X1
    end
  end

  def test_AUTIA
    # AUTIA  <Xd>, <Xn|SP>
    assert_bytes [0x41, 0x10, 0xc1, 0xda] do |asm|
      asm.autia X1, X2
    end
    # AUTIZA  <Xd>
    assert_bytes [0xe1, 0x33, 0xc1, 0xda] do |asm|
      asm.autiza X1
    end
    # AUTIA1716
    assert_one_insn "hint #0xc" do |asm|
      asm.autia1716
    end

    # AUTIASP
    assert_one_insn "hint #0x1d" do |asm|
      asm.autiasp
    end

    # AUTIAZ
    assert_one_insn "hint #0x1c" do |asm|
      asm.autiaz
    end
  end

  def test_AUTIB
    # AUTIB  <Xd>, <Xn|SP>
    assert_bytes [0x41, 0x14, 0xc1, 0xda] do |asm|
      asm.autib X1, X2
    end

    # AUTIZB  <Xd>
    assert_bytes [0xe1, 0x37, 0xc1, 0xda] do |asm|
      asm.autizb X1
    end

    # AUTIB1716
    assert_one_insn "hint #0xe" do |asm|
      asm.autib1716
    end

    # AUTIBSP
    assert_one_insn "hint #0x1f" do |asm|
      asm.autibsp
    end

    # AUTIBZ
    assert_one_insn "hint #0x1e" do |asm|
      asm.autibz
    end
  end

  def test_AXFLAG
    # AXFLAG
    assert_bytes [0x5f, 0x40, 0x00, 0xd5] do |asm|
      asm.axflag
    end
  end

  def test_b
    asm.b 0x8
    assert_one_insn "b #8"
  end

  def test_b_with_label
    label = asm.make_label :foo
    asm.b label
    asm.put_label label
    assert_one_insn "b #4"
  end

  def test_B_cond
    # B.<cond>  <label>
    assert_one_insn "b.pl #4" do |asm|
      label = asm.make_label :foo
      asm.b label, cond: :pl
      asm.put_label label
    end
  end

  def test_BC_cond
    # BC.<cond>  <label>
    assert_bytes [53, 0, 0, 84] do |asm|
      label = asm.make_label :foo
      asm.bc label, cond: :pl
      asm.put_label label
    end
  end

  def test_BFC_BFM
    # BFC  <Wd>, #<lsb>, #<width>
    assert_bytes [0xe4,0x17,0x7f,0xb3] do |asm|
      asm.bfc      x4, 1, 6
    end
    assert_bytes [0xff,0x2b,0x76,0xb3] do |asm|
      asm.bfc      xzr, 10, 11
    end
    assert_bytes [0xe3,0x7f,0x00,0x33] do |asm|
      asm.bfc w3, 0, 32
    end
    assert_bytes [0xff,0x03,0x01,0x33] do |asm|
      asm.bfc wzr, 31, 1
    end
    assert_bytes [0xe0,0x23,0x7b,0xb3] do |asm|
      asm.bfc x0, 5, 9
    end
    assert_bytes [0xff,0x03,0x41,0xb3] do |asm|
      asm.bfc xzr, 63, 1
    end

    # BFC  <Xd>, #<lsb>, #<width>
  end

  def test_BFI_BFM
    # BFI  <Wd>, <Wn>, #<lsb>, #<width>
    assert_bytes [0xa4,0x28,0x4c,0xb3] do |asm|
      asm.bfi      x4, x5, 52, 11
    end
    assert_bytes [0x62,0x00,0x41,0xb3] do |asm|
      asm.bfi      x2, x3, 63, 1
    end
    assert_bytes [0x49,0xe9,0x7b,0xb3] do |asm|
      asm.bfi      x9, x10, 5, 59
    end
    assert_bytes [0x8b,0x01,0x01,0x33] do |asm|
      asm.bfi      w11, w12, 31, 1
    end
    assert_bytes [0xcd,0x09,0x03,0x33] do |asm|
      asm.bfi      w13, w14, 29, 3
    end
  end

  def test_BFM
    # BFM  <Wd>, <Wn>, #<immr>, #<imms>
    assert_one_insn "bfi w4, w5, #0x14, #0xb" do |asm|
      asm.bfm W4, W5, 12, 10
    end

    # BFM  <Xd>, <Xn>, #<immr>, #<imms>
    assert_one_insn "bfi x4, x5, #0x34, #0xb" do |asm|
      asm.bfm X4, X5, 12, 10
    end
  end

  def test_BFXIL_BFM
    # BFXIL  <Wd>, <Wn>, #<lsb>, #<width>
    assert_one_insn "bfxil w9, w10, #0, #1" do |asm|
      asm.bfxil W9, W10, 0, 1
    end

    # BFXIL  <Xd>, <Xn>, #<lsb>, #<width>
    assert_one_insn "bfxil x2, x3, #0x3f, #1" do |asm|
      asm.bfxil X2, X3, 63, 1
    end
  end

  def test_BIC_log_shift
    # BIC  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    assert_bytes [0x41,0x00,0x23,0x0a] do |asm|
      asm.bic w1, w2, w3
    end
    assert_bytes [0x41,0x00,0x23,0x8a] do |asm|
      asm.bic x1, x2, x3
    end
    assert_bytes [0x41,0x0c,0x23,0x0a] do |asm|
      asm.bic w1, w2, w3, lsl(3)
    end
    assert_bytes [0x41,0x0c,0x23,0x8a] do |asm|
      asm.bic x1, x2, x3, lsl(3)
    end
    assert_bytes [0x41,0x0c,0x63,0x0a] do |asm|
      asm.bic w1, w2, w3, lsr(3)
    end
    assert_bytes [0x41,0x0c,0x63,0x8a] do |asm|
      asm.bic x1, x2, x3, lsr(3)
    end
    assert_bytes [0x41,0x0c,0xa3,0x0a] do |asm|
      asm.bic w1, w2, w3, asr(3)
    end
    assert_bytes [0x41,0x0c,0xa3,0x8a] do |asm|
      asm.bic x1, x2, x3, asr(3)
    end
    assert_bytes [0x41,0x0c,0xe3,0x0a] do |asm|
      asm.bic w1, w2, w3, ror(3)
    end
    assert_bytes [0x41,0x0c,0xe3,0x8a] do |asm|
      asm.bic x1, x2, x3, ror(3)
    end
    assert_bytes [0x8d,0xbe,0x2e,0x8a] do |asm|
      asm.bic      x13, x20, x14, lsl(47)
    end
    assert_bytes [0xe2,0x00,0x29,0x0a] do |asm|
      asm.bic      w2, w7, w9
    end
    assert_one_insn "bic w2, w7, w9" do |asm|
      asm.bic W2, W7, W9
    end

    # BIC  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    assert_one_insn "bic x13, x20, x14, lsl #47" do |asm|
      asm.bic X13, X20, X14, shift: :lsl, amount: 47
    end
  end

  def test_BICS
    # BICS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    assert_bytes [0x41,0x00,0x23,0x6a] do |asm|
      asm.bics w1, w2, w3
    end
    assert_bytes [0x41,0x00,0x23,0xea] do |asm|
      asm.bics x1, x2, x3
    end
    assert_bytes [0x41,0x0c,0x23,0x6a] do |asm|
      asm.bics w1, w2, w3, lsl(3)
    end
    assert_bytes [0x41,0x0c,0x23,0xea] do |asm|
      asm.bics x1, x2, x3, lsl(3)
    end
    assert_bytes [0x41,0x0c,0x63,0x6a] do |asm|
      asm.bics w1, w2, w3, lsr(3)
    end
    assert_bytes [0x41,0x0c,0x63,0xea] do |asm|
      asm.bics x1, x2, x3, lsr(3)
    end
    assert_bytes [0x41,0x0c,0xa3,0x6a] do |asm|
      asm.bics w1, w2, w3, asr(3)
    end
    assert_bytes [0x41,0x0c,0xa3,0xea] do |asm|
      asm.bics x1, x2, x3, asr(3)
    end
    assert_bytes [0x41,0x0c,0xe3,0x6a] do |asm|
      asm.bics w1, w2, w3, ror(3)
    end
    assert_bytes [0x41,0x0c,0xe3,0xea] do |asm|
      asm.bics x1, x2, x3, ror(3)
    end
    assert_bytes [0xa3,0x00,0x27,0x6a] do |asm|
      asm.bics     w3, w5, w7
    end
    assert_bytes [0xe3,0x07,0x23,0xea] do |asm|
      asm.bics     x3, xzr, x3, lsl(1)
    end
    assert_one_insn "bics w2, w7, w9" do |asm|
      asm.bics W2, W7, W9
    end

    # BICS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    assert_one_insn "bics x13, x20, x14, lsl #47" do |asm|
      asm.bics X13, X20, X14, shift: :lsl, amount: 47
    end
  end

  def test_BL
    # BL  <label>
    assert_one_insn "bl #4" do |asm|
      label = asm.make_label :foo
      asm.bl label
      asm.put_label label
    end

    assert_bytes [0x00,0x00,0x00,0x94] do |asm|
      asm.bl 0
    end
  end

  def test_BLR
    # BLR  <Xn>
    assert_one_insn "blr x3" do |asm|
      asm.blr X3
    end
  end

  def test_BLRA
    # BLRAAZ  <Xn>
    assert_bytes f("7f 08 3f d6") do |asm|
      asm.blraaz X3
    end

    # BLRAA  <Xn>, <Xm|SP>
    assert_bytes f("61 08 3f d7") do |asm|
      asm.blraa X3, X1
    end

    # BLRABZ  <Xn>
    assert_bytes f("7f 0c 3f d6") do |asm|
      asm.blrabz X3
    end

    # BLRAB  <Xn>, <Xm|SP>
    assert_bytes f("61 0c 3f d7") do |asm|
      asm.blrab X3, X1
    end
  end

  def test_BR
    # BR  <Xn>
    assert_one_insn "br x3" do |asm|
      asm.br X3
    end
  end

  def test_BRA
    # BRAAZ  <Xn>
    assert_bytes f("7f 08 1f d6") do |asm|
      asm.braaz X3
    end
    # BRAA  <Xn>, <Xm|SP>
    assert_bytes f("61 08 1f d7") do |asm|
      asm.braa X3, X1
    end
    # BRABZ  <Xn>
    assert_bytes f("7f 0c 1f d6") do |asm|
      asm.brabz X3
    end
    # BRAB  <Xn>, <Xm|SP>
    assert_bytes f("61 0c 1f d7") do |asm|
      asm.brab X3, X1
    end
  end

  def test_BRK
    # BRK  #<imm>
    asm.brk 1
    assert_one_insn "brk #0x1"
  end

  def test_BTI
    # BTI  {<targets>}
    assert_one_insn "hint #0x20" do |asm|
      asm.bti :c
    end
  end

  def test_CAS
    # CAS  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASA  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASAL  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASL  <Ws>, <Wt>, [<Xn|SP>{,#0}]

    assert_bytes [0x41,0x7c,0xa0,0x88] do |asm|
      asm.cas     W0, W1, [X2]
    end
    assert_bytes [0x41,0x7c,0xe0,0x88] do |asm|
      asm.casa    W0, W1, [X2]
    end
    assert_bytes [0x41,0xfc,0xa0,0x88] do |asm|
      asm.casl    W0, W1, [X2]
    end
    assert_bytes [0x41,0xfc,0xe0,0x88] do |asm|
      asm.casal   W0, W1, [X2]
    end

    # CAS  <Xs>, <Xt>, [<Xn|SP>{,#0}]
    # CASA  <Xs>, <Xt>, [<Xn|SP>{,#0}]
    # CASAL  <Xs>, <Xt>, [<Xn|SP>{,#0}]
    # CASL  <Xs>, <Xt>, [<Xn|SP>{,#0}]

    assert_bytes [0x41,0x7c,0xa0,0xc8] do |asm|
      asm.cas     X0, X1, [X2]
    end
    assert_bytes [0x41,0x7c,0xe0,0xc8] do |asm|
      asm.casa    X0, X1, [X2]
    end
    assert_bytes [0x41,0xfc,0xa0,0xc8] do |asm|
      asm.casl    X0, X1, [X2]
    end
    assert_bytes [0x41,0xfc,0xe0,0xc8] do |asm|
      asm.casal   X0, X1, [X2]
    end
  end

  def test_CASB
    # CASAB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASALB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASLB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x41,0x7c,0xa0,0x08] do |asm|
      asm.casb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x7f,0xa2,0x08] do |asm|
      asm.casb w2, w3, [sp]
    end
    assert_bytes [0x41,0xfc,0xe0,0x08] do |asm|
      asm.casalb w0, w1, [x2]
    end
    assert_bytes [0xe3,0xff,0xe2,0x08] do |asm|
      asm.casalb w2, w3, [sp]
    end
    assert_bytes [0x41,0xfc,0xa0,0x08] do |asm|
      asm.caslb w0, w1, [x2]
    end
    assert_bytes [0xe3,0xff,0xa2,0x08] do |asm|
      asm.caslb w2, w3, [sp]
    end
  end

  def test_CASH
    # CASAH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x41,0x7c,0xe0,0x48] do |asm|
      asm.casah w0, w1, [x2]
    end
    assert_bytes [0xe3,0x7f,0xe2,0x48] do |asm|
      asm.casah w2, w3, [sp]
    end
    # CASALH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x41,0xfc,0xe0,0x48] do |asm|
      asm.casalh w0, w1, [x2]
    end
    assert_bytes [0xe3,0xff,0xe2,0x48] do |asm|
      asm.casalh w2, w3, [sp]
    end
    # CASH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x41,0x7c,0xa0,0x48] do |asm|
      asm.cash w0, w1, [x2]
    end
    assert_bytes [0xe3,0x7f,0xa2,0x48] do |asm|
      asm.cash w2, w3, [sp]
    end
    # CASLH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x41,0xfc,0xa0,0x48] do |asm|
      asm.caslh w0, w1, [x2]
    end
    assert_bytes [0xe3,0xff,0xa2,0x48] do |asm|
      asm.caslh w2, w3, [sp]
    end
  end

  def test_CASP
    assert_bytes [0xa2,0x7c,0x20,0x08] do |asm|
      asm.casp w0, w1, w2, w3, [x5]
    end
    assert_bytes [0xe6,0x7f,0x24,0x08] do |asm|
      asm.casp w4, w5, w6, w7, [sp]
    end
    assert_bytes [0x42,0x7c,0x20,0x48] do |asm|
      asm.casp x0, x1, x2, x3, [x2]
    end
    assert_bytes [0xe6,0x7f,0x24,0x48] do |asm|
      asm.casp x4, x5, x6, x7, [sp]
    end
    assert_bytes [0xa2,0x7c,0x60,0x08] do |asm|
      asm.caspa w0, w1, w2, w3, [x5]
    end
    assert_bytes [0xe6,0x7f,0x64,0x08] do |asm|
      asm.caspa w4, w5, w6, w7, [sp]
    end
    assert_bytes [0x42,0x7c,0x60,0x48] do |asm|
      asm.caspa x0, x1, x2, x3, [x2]
    end
    assert_bytes [0xe6,0x7f,0x64,0x48] do |asm|
      asm.caspa x4, x5, x6, x7, [sp]
    end
    assert_bytes [0xa2,0xfc,0x20,0x08] do |asm|
      asm.caspl w0, w1, w2, w3, [x5]
    end
    assert_bytes [0xe6,0xff,0x24,0x08] do |asm|
      asm.caspl w4, w5, w6, w7, [sp]
    end
    assert_bytes [0x42,0xfc,0x20,0x48] do |asm|
      asm.caspl x0, x1, x2, x3, [x2]
    end
    assert_bytes [0xe6,0xff,0x24,0x48] do |asm|
      asm.caspl x4, x5, x6, x7, [sp]
    end
    assert_bytes [0xa2,0xfc,0x60,0x08] do |asm|
      asm.caspal w0, w1, w2, w3, [x5]
    end
    assert_bytes [0xe6,0xff,0x64,0x08] do |asm|
      asm.caspal w4, w5, w6, w7, [sp]
    end
    assert_bytes [0x42,0xfc,0x60,0x48] do |asm|
      asm.caspal x0, x1, x2, x3, [x2]
    end
    assert_bytes [0xe6,0xff,0x64,0x48] do |asm|
      asm.caspal x4, x5, x6, x7, [sp]
    end
  end

  def test_CBNZ
    # CBNZ  <Wt>, <label>
    # CBNZ  <Xt>, <label>
    assert_bytes [0xe3,0xff,0xff,0xb5] do |asm|
      asm.cbnz x3, -4
    end
    assert_one_insn "cbnz x1, #4" do |asm|
      label = asm.make_label :foo
      asm.cbnz X1, label
      asm.put_label label
    end
  end

  def test_CBZ
    # CBZ  <Wt>, <label>
    # CBZ  <Xt>, <label>
    assert_bytes [0x05,0x00,0x00,0x34] do |asm|
      asm.cbz w5, 0
    end
    assert_bytes [0xf4,0xff,0x7f,0x34] do |asm|
      asm.cbz w20, 1048572
    end
    assert_one_insn "cbz x3, #4" do |asm|
      label = asm.make_label :foo
      asm.cbz X3, label
      asm.put_label label
    end
  end

  def test_CCMN_imm_reg
    # CCMN  <Wn>, #<imm>, #<nzcv>, <cond>
    # CCMN  <Xn>, #<imm>, #<nzcv>, <cond>
    # CCMN  <Wn>, <Wm>, #<nzcv>, <cond>
    # CCMN  <Xn>, <Xm>, #<nzcv>, <cond>
    assert_one_insn "ccmn w1, #0x1f, #0, eq" do |asm|
      asm.ccmn w1, 0x1f, 0, :eq
    end
    assert_one_insn "ccmn w3, #0, #0xf, hs" do |asm|
      asm.ccmn w3, 0, 0xf, :hs
    end
    assert_one_insn "ccmn wzr, #0xf, #0xd, hs" do |asm|
      asm.ccmn wzr, 0xf, 0xd, :hs
    end
    assert_one_insn "ccmn x9, #0x1f, #0, le" do |asm|
      asm.ccmn x9, 31, 0, :le
    end
    assert_one_insn "ccmn x3, #0, #0xf, gt" do |asm|
      asm.ccmn x3, 0, 15, :gt
    end
    assert_one_insn "ccmn xzr, #5, #7, ne" do |asm|
      asm.ccmn xzr, 5, 7, :ne
    end
    assert_one_insn "ccmn w1, wzr, #0, eq" do |asm|
      asm.ccmn w1, wzr, 0, :eq
    end
    assert_one_insn "ccmn w3, w0, #0xf, hs" do |asm|
      asm.ccmn w3, w0, 15, :hs
    end
    assert_one_insn "ccmn wzr, w15, #0xd, hs" do |asm|
      asm.ccmn wzr, w15, 13, :hs
    end
    assert_one_insn "ccmn x9, xzr, #0, le" do |asm|
      asm.ccmn x9, xzr, 0, :le
    end
    assert_one_insn "ccmn x3, x0, #0xf, gt" do |asm|
      asm.ccmn x3, x0, 15, :gt
    end
    assert_one_insn "ccmn xzr, x5, #7, ne" do |asm|
      asm.ccmn xzr, x5, 7, :ne
    end
  end

  def test_CCMP_imm_reg
    # CCMP  <Wn>, #<imm>, #<nzcv>, <cond>
    # CCMP  <Xn>, #<imm>, #<nzcv>, <cond>
    # CCMP  <Wn>, <Wm>, #<nzcv>, <cond>
    # CCMP  <Xn>, <Xm>, #<nzcv>, <cond>

    assert_one_insn "ccmp w1, #0x1f, #0, eq" do |asm|
      asm.ccmp w1, 31, 0, :eq
    end
    assert_one_insn "ccmp w3, #0, #0xf, hs" do |asm|
      asm.ccmp w3, 0, 15, :hs
    end
    assert_one_insn "ccmp wzr, #0xf, #0xd, hs" do |asm|
      asm.ccmp wzr, 15, 13, :hs
    end
    assert_one_insn "ccmp x9, #0x1f, #0, le" do |asm|
      asm.ccmp x9, 31, 0, :le
    end
    assert_one_insn "ccmp x3, #0, #0xf, gt" do |asm|
      asm.ccmp x3, 0, 15, :gt
    end
    assert_one_insn "ccmp xzr, #5, #7, ne" do |asm|
      asm.ccmp xzr, 5, 7, :ne
    end
    assert_one_insn "ccmp w1, wzr, #0, eq" do |asm|
      asm.ccmp w1, wzr, 0, :eq
    end
    assert_one_insn "ccmp w3, w0, #0xf, hs" do |asm|
      asm.ccmp w3, w0, 15, :hs
    end
    assert_one_insn "ccmp wzr, w15, #0xd, hs" do |asm|
      asm.ccmp wzr, w15, 13, :hs
    end
    assert_one_insn "ccmp x9, xzr, #0, le" do |asm|
      asm.ccmp x9, xzr, 0, :le
    end
    assert_one_insn "ccmp x3, x0, #0xf, gt" do |asm|
      asm.ccmp x3, x0, 15, :gt
    end
    assert_one_insn "ccmp xzr, x5, #7, ne" do |asm|
      asm.ccmp xzr, x5, 7, :ne
    end
  end

  def test_CFINV
    # CFINV
    assert_bytes f("1f 40 00 d5") do |asm|
      asm.cfinv
    end
  end

  def test_CFP_SYS
    # CFP  RCTX, <Xt>
    # SYS #3, C7, C3, #4, <Xt>
    assert_bytes f("83 73 0b d5") do |asm|
      asm.cfp_rcfx x3
    end
  end

  def test_CINC_CSINC
    # CINC  <Wd>, <Wn>, <cond>
    # CSINC <Wd>, <Wn>, <Wn>, invert(<cond>)
    # CINC  <Xd>, <Xn>, <cond>
    # CSINC <Xd>, <Xn>, <Xn>, invert(<cond>)

    assert_one_insn "cinc w3, w5, gt" do |asm|
      asm.cinc w3, w5, :gt
    end
    assert_one_insn "cinc wzr, w4, le" do |asm|
      asm.cinc wzr, w4, :le
    end
    assert_one_insn "cinc x3, x5, gt" do |asm|
      asm.cinc x3, x5, :gt
    end
    assert_one_insn "cinc xzr, x4, le" do |asm|
      asm.cinc xzr, x4, :le
    end
    assert_one_insn "csinc w1, w0, w19, ne" do |asm|
      asm.csinc w1, w0, w19, :ne
    end
    assert_one_insn "csinc wzr, w5, w9, eq" do |asm|
      asm.csinc wzr, w5, w9, :eq
    end
    assert_one_insn "csinc w9, wzr, w30, gt" do |asm|
      asm.csinc w9, wzr, w30, :gt
    end
    assert_one_insn "csinc w1, w28, wzr, mi" do |asm|
      asm.csinc w1, w28, wzr, :mi
    end
    assert_one_insn "csinc x19, x23, x29, lt" do |asm|
      asm.csinc x19, x23, x29, :lt
    end
    assert_one_insn "csinc xzr, x3, x4, ge" do |asm|
      asm.csinc xzr, x3, x4, :ge
    end
    assert_one_insn "csinc x5, xzr, x6, hs" do |asm|
      asm.csinc x5, xzr, x6, :hs
    end
    assert_one_insn "csinc x7, x8, xzr, lo" do |asm|
      asm.csinc x7, x8, xzr, :lo
    end
  end

  def test_CINV_CSINV
    # CINV  <Wd>, <Wn>, <cond>
    # CSINV <Wd>, <Wn>, <Wn>, invert(<cond>)
    # CINV  <Xd>, <Xn>, <cond>
    # CSINV <Xd>, <Xn>, <Xn>, invert(<cond>)
    assert_bytes [0xa3,0xd0,0x85,0x5a] do |asm|
      asm.cinv    w3, w5, gt
    end
    assert_bytes [0x9f,0xc0,0x84,0x5a] do |asm|
      asm.cinv    wzr, w4, le
    end
    assert_bytes [0xa3,0xd0,0x85,0xda] do |asm|
      asm.cinv    x3, x5, gt
    end
    assert_bytes [0x9f,0xc0,0x84,0xda] do |asm|
      asm.cinv    xzr, x4, le
    end
    assert_bytes [0x01,0x10,0x93,0x5a] do |asm|
      asm.csinv    w1, w0, w19, ne
    end
    assert_bytes [0xbf,0x00,0x89,0x5a] do |asm|
      asm.csinv    wzr, w5, w9, eq
    end
    assert_bytes [0xe9,0xc3,0x9e,0x5a] do |asm|
      asm.csinv    w9, wzr, w30, gt
    end
    assert_bytes [0x81,0x43,0x9f,0x5a] do |asm|
      asm.csinv    w1, w28, wzr, mi
    end
    assert_bytes [0xf3,0xb2,0x9d,0xda] do |asm|
      asm.csinv    x19, x23, x29, lt
    end
    assert_bytes [0x7f,0xa0,0x84,0xda] do |asm|
      asm.csinv    xzr, x3, x4, ge
    end
    assert_bytes [0xe5,0x23,0x86,0xda] do |asm|
      asm.csinv    x5, xzr, x6, hs
    end
    assert_bytes [0x07,0x31,0x9f,0xda] do |asm|
      asm.csinv    x7, x8, xzr, lo
    end
  end

  def test_CLREX
    # CLREX  {#<imm>}
    assert_bytes [0x5f,0x3f,0x03,0xd5] do |asm|
      asm.clrex
    end
    assert_bytes [0x5f,0x30,0x03,0xd5] do |asm|
      asm.clrex   0
    end
    assert_bytes [0x5f,0x37,0x03,0xd5] do |asm|
      asm.clrex   7
    end
    assert_bytes [0x5f,0x3f,0x03,0xd5] do |asm|
      asm.clrex
    end
  end

  def test_CLS_int
    # CLS  <Wd>, <Wn>
    # CLS  <Xd>, <Xn>
    assert_bytes [0xa3,0x14,0xc0,0x5a] do |asm|
      asm.cls	w3, w5
    end
    assert_bytes [0xb4,0x14,0xc0,0xda] do |asm|
      asm.cls	x20, x5
    end
  end

  def test_CLZ_int
    # CLZ  <Wd>, <Wn>
    # CLZ  <Xd>, <Xn>
    assert_bytes [0x78,0x10,0xc0,0x5a] do |asm|
      asm.clz	w24, w3
    end
    assert_bytes [0x9a,0x10,0xc0,0xda] do |asm|
      asm.clz	x26, x4
    end
    assert_bytes [0xf8,0x13,0xc0,0x5a] do |asm|
      asm.clz	w24, wzr
    end
  end

  def test_CMN_ADDS_addsub_ext
    # CMN  <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # ADDS WZR, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # CMN  <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    # ADDS XZR, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    assert_bytes [0x5f,0xc0,0x23,0x2b] do |asm|
      asm.cmn w2, w3, sxtw
    end
    assert_bytes [0x9f,0x08,0x25,0xab] do |asm|
      asm.cmn      x4, w5, uxtb(2)
    end
    assert_bytes [0xff,0x33,0x33,0xab] do |asm|
      asm.cmn      sp, w19, uxth(4)
    end
    assert_bytes [0x3f,0x40,0x34,0xab] do |asm|
      asm.cmn      x1, w20, uxtw
    end
    assert_bytes [0x7f,0x60,0x2d,0xab] do |asm|
      asm.cmn      x3, x13, uxtx
    end
    assert_bytes [0x3f,0x8f,0x34,0xab] do |asm|
      asm.cmn      x25, w20, sxtb(3)
    end
    assert_bytes [0xff,0xa3,0x33,0xab] do |asm|
      asm.cmn      sp, w19, sxth
    end
    assert_bytes [0x5f,0xc0,0x23,0xab] do |asm|
      asm.cmn      x2, w3, sxtw
    end
    assert_bytes [0xbf,0xe8,0x29,0xab] do |asm|
      asm.cmn      x5, x9, sxtx(2)
    end
    assert_bytes [0xff,0x53,0x23,0x2b] do |asm|
      asm.cmn wsp, w3, lsl(4)
    end
    assert_bytes [0x7f,0x8c,0x44,0x31] do |asm|
      asm.cmn      w3, 291, lsl(12)
    end
    assert_bytes [0xff,0x57,0x15,0x31] do |asm|
      asm.cmn      wsp, 1365
    end
    assert_bytes [0xff,0x13,0x51,0xb1] do |asm|
      asm.cmn      sp, 1092, lsl(12)
    end
    assert_bytes [0x1f,0x00,0x03,0x2b] do |asm|
      asm.cmn      w0, w3
    end
    assert_bytes [0xff,0x03,0x04,0x2b] do |asm|
      asm.cmn      wzr, w4
    end
    assert_bytes [0xbf,0x00,0x1f,0x2b] do |asm|
      asm.cmn      w5, wzr
    end
    assert_bytes [0xff,0x43,0x26,0x2b] do |asm|
      asm.cmn      wsp, w6
    end
    assert_bytes [0xdf,0x00,0x07,0x2b] do |asm|
      asm.cmn      w6, w7
    end
    assert_bytes [0x1f,0x3d,0x09,0x2b] do |asm|
      asm.cmn      w8, w9, lsl(15)
    end
    assert_bytes [0x5f,0x7d,0x0b,0x2b] do |asm|
      asm.cmn      w10, w11, lsl(31)
    end
    assert_bytes [0x9f,0x01,0x4d,0x2b] do |asm|
      asm.cmn      w12, w13, lsr(0)
    end
    assert_bytes [0xdf,0x55,0x4f,0x2b] do |asm|
      asm.cmn      w14, w15, lsr(21)
    end
    assert_bytes [0x1f,0x7e,0x51,0x2b] do |asm|
      asm.cmn      w16, w17, lsr(31)
    end
    assert_bytes [0x5f,0x02,0x93,0x2b] do |asm|
      asm.cmn      w18, w19, asr(0)
    end
    assert_bytes [0x9f,0x5a,0x95,0x2b] do |asm|
      asm.cmn      w20, w21, asr(22)
    end
    assert_bytes [0xdf,0x7e,0x97,0x2b] do |asm|
      asm.cmn      w22, w23, asr(31)
    end
    assert_bytes [0x1f,0x00,0x03,0xab] do |asm|
      asm.cmn      x0, x3
    end
    assert_bytes [0xff,0x03,0x04,0xab] do |asm|
      asm.cmn      xzr, x4
    end
    assert_bytes [0xbf,0x00,0x1f,0xab] do |asm|
      asm.cmn      x5, xzr
    end
    assert_bytes [0xff,0x63,0x26,0xab] do |asm|
      asm.cmn      sp, x6
    end
    assert_bytes [0xdf,0x00,0x07,0xab] do |asm|
      asm.cmn      x6, x7
    end
    assert_bytes [0x1f,0x3d,0x09,0xab] do |asm|
      asm.cmn      x8, x9, lsl(15)
    end
    assert_bytes [0x5f,0xfd,0x0b,0xab] do |asm|
      asm.cmn      x10, x11, lsl(63)
    end
    assert_bytes [0x9f,0x01,0x4d,0xab] do |asm|
      asm.cmn      x12, x13, lsr(0)
    end
    assert_bytes [0xdf,0xa5,0x4f,0xab] do |asm|
      asm.cmn      x14, x15, lsr(41)
    end
    assert_bytes [0x1f,0xfe,0x51,0xab] do |asm|
      asm.cmn      x16, x17, lsr(63)
    end
    assert_bytes [0x5f,0x02,0x93,0xab] do |asm|
      asm.cmn      x18, x19, asr(0)
    end
    assert_bytes [0x9f,0xde,0x95,0xab] do |asm|
      asm.cmn      x20, x21, asr(55)
    end
    assert_bytes [0xdf,0xfe,0x97,0xab] do |asm|
      asm.cmn      x22, x23, asr(63)
    end
  end

  def test_CMN_ADDS_addsub_imm
    # CMN  <Wn|WSP>, #<imm>{, <shift>}
    # ADDS WZR, <Wn|WSP>, #<imm> {, <shift>}
    assert_one_insn "cmn wsp, #0x555" do |asm|
      asm.cmn wsp, 1365
    end
    assert_one_insn "cmn wsp, #0x555, lsl #12" do |asm|
      asm.cmn wsp, 1365, lsl: 12
    end

    # CMN  <Xn|SP>, #<imm>{, <shift>}
    # ADDS XZR, <Xn|SP>, #<imm> {, <shift>}
    assert_one_insn "cmn x18, #0x555" do |asm|
      asm.cmn x18, 1365
    end
    assert_one_insn "cmn x18, #0x555, lsl #12" do |asm|
      asm.cmn x18, 1365, lsl: 12
    end
  end

  def test_CMN_ADDS_addsub_shift
    # CMN  <Wn>, <Wm>{, <shift> #<amount>}
    #assert_one_insn "cmn w0, w3" do |asm|
    #  asm.cmn w0, w3
    #end

    assert_bytes f("ff 63 23 ab") do |asm|
      asm.cmn sp, x3
    end

    [:lsl].each do |shift|
      4.times do |i|
        str = if i == 0
                "cmn wsp, w3"
              else
                "cmn wsp, w3, #{shift} ##{i}"
              end
        assert_one_insn str do |asm|
          asm.cmn wsp, w3, shift: shift, amount: i
        end
      end
    end

    # CMN  <Xn>, <Xm>{, <shift> #<amount>}
    [:lsl, :lsr, :asr].each do |shift|
      4.times do |i|
        str = if i == 0
                if shift == :lsl
                  "cmn x18, x19"
                else
                  "cmn x18, x19, #{shift} #0"
                end
              else
                "cmn x18, x19, #{shift} ##{i}"
              end
        assert_one_insn str do |asm|
          asm.cmn x18, x19, shift: shift, amount: i
        end
      end
    end
  end

  def test_CMP_SUBS_all
    assert_bytes [0x9f,0x08,0x25,0xeb] do |asm|
      asm.cmp      x4, w5, uxtb(2)
    end
    assert_bytes [0xff,0x33,0x33,0xeb] do |asm|
      asm.cmp      sp, w19, uxth(4)
    end
    assert_bytes [0x3f,0x40,0x34,0xeb] do |asm|
      asm.cmp      x1, w20, uxtw
    end
    assert_bytes [0x7f,0x60,0x2d,0xeb] do |asm|
      asm.cmp      x3, x13, uxtx
    end
    assert_bytes [0x3f,0x8f,0x34,0xeb] do |asm|
      asm.cmp      x25, w20, sxtb(3)
    end
    assert_bytes [0xff,0xa3,0x33,0xeb] do |asm|
      asm.cmp      sp, w19, sxth
    end
    assert_bytes [0x5f,0xc0,0x23,0xeb] do |asm|
      asm.cmp      x2, w3, sxtw
    end
    assert_bytes [0xbf,0xe8,0x29,0xeb] do |asm|
      asm.cmp      x5, x9, sxtx(2)
    end
    assert_bytes [0xbf,0x00,0x27,0x6b] do |asm|
      asm.cmp      w5, w7, uxtb
    end
    assert_bytes [0xff,0x21,0x31,0x6b] do |asm|
      asm.cmp      w15, w17, uxth
    end
    assert_bytes [0xbf,0x43,0x3f,0x6b] do |asm|
      asm.cmp      w29, wzr, uxtw
    end
    assert_bytes [0x3f,0x62,0x21,0x6b] do |asm|
      asm.cmp      w17, w1, uxtx
    end
    assert_bytes [0xbf,0x84,0x21,0x6b] do |asm|
      asm.cmp      w5, w1, sxtb(1)
    end
    assert_bytes [0xff,0xa3,0x33,0x6b] do |asm|
      asm.cmp      wsp, w19, sxth
    end
    assert_bytes [0x5f,0xc0,0x23,0x6b] do |asm|
      asm.cmp      w2, w3, sxtw
    end
    assert_bytes [0x7f,0xe0,0x25,0x6b] do |asm|
      asm.cmp      w3, w5, sxtx
    end
    assert_bytes [0x9f,0x0e,0x3d,0xeb] do |asm|
      asm.cmp      x20, w29, uxtb(3)
    end
    assert_bytes [0x9f,0x71,0x2d,0xeb] do |asm|
      asm.cmp      x12, x13, uxtx(4)
    end
    assert_bytes [0xff,0x03,0x21,0x6b] do |asm|
      asm.cmp      wsp, w1, uxtb
    end
    assert_bytes [0xff,0x43,0x29,0x6b] do |asm|
      asm.cmp      wsp, w9
    end
    assert_bytes [0x9f,0xb0,0x44,0xf1] do |asm|
      asm.cmp      x4, 300, lsl(12)
    end
    assert_bytes [0xff,0xd3,0x07,0x71] do |asm|
      asm.cmp      wsp, 500
    end
    assert_bytes [0xff,0x23,0x03,0xf1] do |asm|
      asm.cmp      sp, 200
    end
    assert_bytes [0x1f,0x00,0x03,0x6b] do |asm|
      asm.cmp      w0, w3
    end
    assert_bytes [0xff,0x03,0x04,0x6b] do |asm|
      asm.cmp      wzr, w4
    end
    assert_bytes [0xbf,0x00,0x1f,0x6b] do |asm|
      asm.cmp      w5, wzr
    end
    assert_bytes [0xff,0x43,0x26,0x6b] do |asm|
      asm.cmp      wsp, w6
    end
    assert_bytes [0xdf,0x00,0x07,0x6b] do |asm|
      asm.cmp      w6, w7
    end
    assert_bytes [0x1f,0x3d,0x09,0x6b] do |asm|
      asm.cmp      w8, w9, lsl(15)
    end
    assert_bytes [0x5f,0x7d,0x0b,0x6b] do |asm|
      asm.cmp      w10, w11, lsl(31)
    end
    assert_bytes [0x9f,0x01,0x4d,0x6b] do |asm|
      asm.cmp      w12, w13, lsr(0)
    end
    assert_bytes [0xdf,0x55,0x4f,0x6b] do |asm|
      asm.cmp      w14, w15, lsr(21)
    end
    assert_bytes [0x1f,0x7e,0x51,0x6b] do |asm|
      asm.cmp      w16, w17, lsr(31)
    end
    assert_bytes [0x5f,0x02,0x93,0x6b] do |asm|
      asm.cmp      w18, w19, asr(0)
    end
    assert_bytes [0x9f,0x5a,0x95,0x6b] do |asm|
      asm.cmp      w20, w21, asr(22)
    end
    assert_bytes [0xdf,0x7e,0x97,0x6b] do |asm|
      asm.cmp      w22, w23, asr(31)
    end
    assert_bytes [0x1f,0x00,0x03,0xeb] do |asm|
      asm.cmp      x0, x3
    end
    assert_bytes [0xff,0x03,0x04,0xeb] do |asm|
      asm.cmp      xzr, x4
    end
    assert_bytes [0xbf,0x00,0x1f,0xeb] do |asm|
      asm.cmp      x5, xzr
    end
    assert_bytes [0xff,0x63,0x26,0xeb] do |asm|
      asm.cmp      sp, x6
    end
    assert_bytes [0xdf,0x00,0x07,0xeb] do |asm|
      asm.cmp      x6, x7
    end
    assert_bytes [0x1f,0x3d,0x09,0xeb] do |asm|
      asm.cmp      x8, x9, lsl(15)
    end
    assert_bytes [0x5f,0xfd,0x0b,0xeb] do |asm|
      asm.cmp      x10, x11, lsl(63)
    end
    assert_bytes [0x9f,0x01,0x4d,0xeb] do |asm|
      asm.cmp      x12, x13, lsr(0)
    end
    assert_bytes [0xdf,0xa5,0x4f,0xeb] do |asm|
      asm.cmp      x14, x15, lsr(41)
    end
    assert_bytes [0x1f,0xfe,0x51,0xeb] do |asm|
      asm.cmp      x16, x17, lsr(63)
    end
    assert_bytes [0x5f,0x02,0x93,0xeb] do |asm|
      asm.cmp      x18, x19, asr(0)
    end
    assert_bytes [0x9f,0xde,0x95,0xeb] do |asm|
      asm.cmp      x20, x21, asr(55)
    end
    assert_bytes [0xdf,0xfe,0x97,0xeb] do |asm|
      asm.cmp      x22, x23, asr(63)
    end
    assert_bytes [0xff,0x03,0x00,0x6b] do |asm|
      asm.cmp      wzr, w0
    end
    assert_bytes [0xff,0x03,0x00,0xeb] do |asm|
      asm.cmp     xzr, x0
    end
  end

  def test_CMPP_SUBPS
    # CMPP  <Xn|SP>, <Xm|SP>
    assert_bytes [0x3f, 0, 0xc2, 0xba] do |asm|
      asm.cmpp x1, x2
    end
    # SUBPS XZR, <Xn|SP>, <Xm|SP>
    assert_bytes [0x3f, 0, 0xc2, 0xba] do |asm|
      asm.subps xzr, x1, x2
    end
  end

  def test_CNEG_CSNEG
    # CNEG  <Wd>, <Wn>, <cond>
    # CNEG  <Xd>, <Xn>, <cond>
    assert_bytes [0xa3,0xd4,0x85,0x5a] do |asm|
      asm.cneg    w3, w5, gt
    end
    assert_bytes [0x9f,0xc4,0x84,0x5a] do |asm|
      asm.cneg    wzr, w4, le
    end
    assert_bytes [0xe9,0xa7,0x9f,0x5a] do |asm|
      asm.cneg    w9, wzr, lt
    end
    assert_bytes [0xa3,0xd4,0x85,0xda] do |asm|
      asm.cneg    x3, x5, gt
    end
    assert_bytes [0x9f,0xc4,0x84,0xda] do |asm|
      asm.cneg    xzr, x4, le
    end
    assert_bytes [0xe9,0xa7,0x9f,0xda] do |asm|
      asm.cneg    x9, xzr, lt
    end
  end

  def test_CPP_SYS
    # CPP  RCTX, <Xt>
    assert_bytes [0xe3, 0x73, 0xb, 0xd5] do |asm|
      asm.cpp :rctx, x3
    end

    # SYS #3, C7, C3, #7, <Xt>
    assert_bytes [0xe3, 0x73, 0xb, 0xd5] do |asm|
      asm.sys 3, c7, c3, 7, x3
    end
  end

  def test_CRC32
    # CRC32B  <Wd>, <Wn>, <Wm>
    # CRC32H  <Wd>, <Wn>, <Wm>
    # CRC32W  <Wd>, <Wn>, <Wm>
    # CRC32X  <Wd>, <Wn>, <Xm>
    assert_bytes [0xe5,0x40,0xd4,0x1a] do |asm|
      asm.crc32b   w5, w7, w20
    end
    assert_bytes [0xfc,0x47,0xde,0x1a] do |asm|
      asm.crc32h   w28, wzr, w30
    end
    assert_bytes [0x20,0x48,0xc2,0x1a] do |asm|
      asm.crc32w   w0, w1, w2
    end
    assert_bytes [0x27,0x4d,0xd4,0x9a] do |asm|
      asm.crc32x   w7, w9, x20
    end
  end

  def test_CRC32C
    # CRC32CB  <Wd>, <Wn>, <Wm>
    # CRC32CH  <Wd>, <Wn>, <Wm>
    # CRC32CW  <Wd>, <Wn>, <Wm>
    # CRC32CX  <Wd>, <Wn>, <Xm>
    assert_bytes [0xa9,0x50,0xc4,0x1a] do |asm|
      asm.crc32cb  w9, w5, w4
    end
    assert_bytes [0x2d,0x56,0xd9,0x1a] do |asm|
      asm.crc32ch  w13, w17, w25
    end
    assert_bytes [0x7f,0x58,0xc5,0x1a] do |asm|
      asm.crc32cw  wzr, w3, w5
    end
    assert_bytes [0x12,0x5e,0xdf,0x9a] do |asm|
      asm.crc32cx  w18, w16, xzr
    end
  end

  def test_CSDB
    # CSDB
    assert_bytes f("9f 22 03 d5") do |asm|
      asm.csdb
    end
  end

  def test_CSEL
    # CSEL  <Wd>, <Wn>, <Wm>, <cond>
    # CSEL  <Xd>, <Xn>, <Xm>, <cond>
    assert_bytes [0x01,0x10,0x93,0x1a] do |asm|
      asm.csel     w1, w0, w19, ne
    end
    assert_bytes [0xbf,0x00,0x89,0x1a] do |asm|
      asm.csel     wzr, w5, w9, eq
    end
    assert_bytes [0xe9,0xc3,0x9e,0x1a] do |asm|
      asm.csel     w9, wzr, w30, gt
    end
    assert_bytes [0x81,0x43,0x9f,0x1a] do |asm|
      asm.csel     w1, w28, wzr, mi
    end
    assert_bytes [0xf3,0xb2,0x9d,0x9a] do |asm|
      asm.csel     x19, x23, x29, lt
    end
    assert_bytes [0x7f,0xa0,0x84,0x9a] do |asm|
      asm.csel     xzr, x3, x4, ge
    end
    assert_bytes [0xe5,0x23,0x86,0x9a] do |asm|
      asm.csel     x5, xzr, x6, hs
    end
    assert_bytes [0x07,0x31,0x9f,0x9a] do |asm|
      asm.csel     x7, x8, xzr, lo
    end
  end

  def test_CSET_CSINC
    # CSET  <Wd>, <cond>
    # CSET  <Xd>, <cond>
    assert_bytes [0xe3,0x17,0x9f,0x1a] do |asm|
      asm.cset    w3, eq
    end
    assert_bytes [0xe9,0x47,0x9f,0x9a] do |asm|
      asm.cset    x9, pl
    end
    assert_bytes [0xe9,0xa7,0x9f,0x1a] do |asm|
      asm.cset    w9, lt
    end
    assert_bytes [0xe9,0xa7,0x9f,0x9a] do |asm|
      asm.cset     x9, lt
    end
  end

  def test_CSETM_CSINV
    # CSETM  <Wd>, <cond>
    # CSINV <Wd>, WZR, WZR, invert(<cond>)
    # CSETM  <Xd>, <cond>
    # CSINV <Xd>, XZR, XZR, invert(<cond>)
    assert_bytes [0xf4,0x03,0x9f,0x5a] do |asm|
      asm.csetm    w20, ne
    end
    assert_bytes [0xfe,0xb3,0x9f,0xda] do |asm|
      asm.csetm    x30, ge
    end
    assert_bytes [0xe9,0xa3,0x9f,0x5a] do |asm|
      asm.csetm    w9, lt
    end
    assert_bytes [0xe9,0xa3,0x9f,0xda] do |asm|
      asm.csetm    x9, lt
    end
  end

  def test_CSINC
    # CSINC  <Wd>, <Wn>, <Wm>, <cond>
    # CSINC  <Xd>, <Xn>, <Xm>, <cond>
    assert_bytes [0x01,0x14,0x93,0x1a] do |asm|
      asm.csinc    w1, w0, w19, ne
    end
    assert_bytes [0xbf,0x04,0x89,0x1a] do |asm|
      asm.csinc    wzr, w5, w9, eq
    end
    assert_bytes [0xe9,0xc7,0x9e,0x1a] do |asm|
      asm.csinc    w9, wzr, w30, gt
    end
    assert_bytes [0x81,0x47,0x9f,0x1a] do |asm|
      asm.csinc    w1, w28, wzr, mi
    end
    assert_bytes [0xf3,0xb6,0x9d,0x9a] do |asm|
      asm.csinc    x19, x23, x29, lt
    end
    assert_bytes [0x7f,0xa4,0x84,0x9a] do |asm|
      asm.csinc    xzr, x3, x4, ge
    end
    assert_bytes [0xe5,0x27,0x86,0x9a] do |asm|
      asm.csinc    x5, xzr, x6, hs
    end
    assert_bytes [0x07,0x35,0x9f,0x9a] do |asm|
      asm.csinc    x7, x8, xzr, lo
    end
  end

  def test_CSINV
    # CSINV  <Wd>, <Wn>, <Wm>, <cond>
    # CSINV  <Xd>, <Xn>, <Xm>, <cond>
    assert_bytes [0x01,0x10,0x93,0x5a] do |asm|
      asm.csinv    w1, w0, w19, ne
    end
    assert_bytes [0xbf,0x00,0x89,0x5a] do |asm|
      asm.csinv    wzr, w5, w9, eq
    end
    assert_bytes [0xe9,0xc3,0x9e,0x5a] do |asm|
      asm.csinv    w9, wzr, w30, gt
    end
    assert_bytes [0x81,0x43,0x9f,0x5a] do |asm|
      asm.csinv    w1, w28, wzr, mi
    end
    assert_bytes [0xf3,0xb2,0x9d,0xda] do |asm|
      asm.csinv    x19, x23, x29, lt
    end
    assert_bytes [0x7f,0xa0,0x84,0xda] do |asm|
      asm.csinv    xzr, x3, x4, ge
    end
    assert_bytes [0xe5,0x23,0x86,0xda] do |asm|
      asm.csinv    x5, xzr, x6, hs
    end
    assert_bytes [0x07,0x31,0x9f,0xda] do |asm|
      asm.csinv    x7, x8, xzr, lo
    end
  end

  def test_CSNEG
    # CSNEG  <Wd>, <Wn>, <Wm>, <cond>
    # CSNEG  <Xd>, <Xn>, <Xm>, <cond>
    assert_bytes [0x01,0x14,0x93,0x5a] do |asm|
      asm.csneg    w1, w0, w19, ne
    end
    assert_bytes [0xbf,0x04,0x89,0x5a] do |asm|
      asm.csneg    wzr, w5, w9, eq
    end
    assert_bytes [0xe9,0xc7,0x9e,0x5a] do |asm|
      asm.csneg    w9, wzr, w30, gt
    end
    assert_bytes [0x81,0x47,0x9f,0x5a] do |asm|
      asm.csneg    w1, w28, wzr, mi
    end
    assert_bytes [0xf3,0xb6,0x9d,0xda] do |asm|
      asm.csneg    x19, x23, x29, lt
    end
    assert_bytes [0x7f,0xa4,0x84,0xda] do |asm|
      asm.csneg    xzr, x3, x4, ge
    end
    assert_bytes [0xe5,0x27,0x86,0xda] do |asm|
      asm.csneg    x5, xzr, x6, hs
    end
    assert_bytes [0x07,0x35,0x9f,0xda] do |asm|
      asm.csneg    x7, x8, xzr, lo
    end
  end

  def test_DC_SYS
    # DC  <dc_op>, <Xt>
    # SYS #<op1>, C7, <Cm>, #<op2>, <Xt>
    assert_bytes [0x2c,0x74,0x0b,0xd5] do |asm|
      asm.dc      :zva, x12
    end
    assert_bytes [0x3f,0x76,0x08,0xd5] do |asm|
      asm.dc      :ivac, xzr
    end
    assert_bytes [0x42,0x76,0x08,0xd5] do |asm|
      asm.dc      :isw, x2
    end
    assert_bytes [0x29,0x7a,0x0b,0xd5] do |asm|
      asm.dc      :cvac, x9
    end
    assert_bytes [0x4a,0x7a,0x08,0xd5] do |asm|
      asm.dc      :csw, x10
    end
    assert_bytes [0x20,0x7b,0x0b,0xd5] do |asm|
      asm.dc      :cvau, x0
    end
    assert_bytes [0x23,0x7e,0x0b,0xd5] do |asm|
      asm.dc      :civac, x3
    end
    assert_bytes [0x5e,0x7e,0x08,0xd5] do |asm|
      asm.dc      :cisw, x30
    end
  end

  def test_DCPS
    # DCPS1  {#<imm>}
    # DCPS2  {#<imm>}
    # DCPS3  {#<imm>}
    assert_bytes [0x01,0x00,0xa0,0xd4] do |asm|
      asm.dcps1
    end
    assert_bytes [0x02,0x00,0xa0,0xd4] do |asm|
      asm.dcps2
    end
    assert_bytes [0x03,0x00,0xa0,0xd4] do |asm|
      asm.dcps3
    end
  end

  def test_DGH
    # DGH
    assert_bytes f("df 20 03 d5") do |asm|
      asm.dgh
    end
  end

  def test_DMB
    # DMB  <option>|#<imm>
    assert_one_insn "dmb nshst" do |asm|
      asm.dmb 6
    end
    assert_one_insn "dmb ishst" do |asm|
      asm.dmb :ISHST
    end
    assert_one_insn "dmb sy" do |asm|
      asm.dmb :sy
    end
    %w{ oshld oshst osh nshld nshst nsh ishld ishst ish ld st sy }.each do |x|
      assert_one_insn "dmb #{x}" do |asm|
        asm.dmb x
      end
    end
  end

  def test_DRPS
    # DRPS
    assert_bytes f("e0 03 bf d6") do |asm|
      asm.drps
    end
  end

  def test_DSB
    # DSB  <option>|#<imm>
    # DSB  <option>nXS|#<imm>
    assert_bytes [0x9f,0x30,0x03,0xd5] do |asm|
      asm.dsb     0
    end
    assert_bytes [0x9f,0x3c,0x03,0xd5] do |asm|
      asm.dsb     12
    end
    assert_bytes [0x9f,0x3f,0x03,0xd5] do |asm|
      asm.dsb     :sy
    end
    assert_bytes [0x9f,0x31,0x03,0xd5] do |asm|
      asm.dsb     :oshld
    end
    assert_bytes [0x9f,0x32,0x03,0xd5] do |asm|
      asm.dsb     :oshst
    end
    assert_bytes [0x9f,0x33,0x03,0xd5] do |asm|
      asm.dsb     :osh
    end
    assert_bytes [0x9f,0x35,0x03,0xd5] do |asm|
      asm.dsb     :nshld
    end
    assert_bytes [0x9f,0x36,0x03,0xd5] do |asm|
      asm.dsb     :nshst
    end
    assert_bytes [0x9f,0x37,0x03,0xd5] do |asm|
      asm.dsb     :nsh
    end
    assert_bytes [0x9f,0x39,0x03,0xd5] do |asm|
      asm.dsb     :ishld
    end
    assert_bytes [0x9f,0x3a,0x03,0xd5] do |asm|
      asm.dsb     :ishst
    end
    assert_bytes [0x9f,0x3b,0x03,0xd5] do |asm|
      asm.dsb     :ish
    end
    assert_bytes [0x9f,0x3d,0x03,0xd5] do |asm|
      asm.dsb     :ld
    end
    assert_bytes [0x9f,0x3e,0x03,0xd5] do |asm|
      asm.dsb     :st
    end
    assert_bytes [0x9f,0x3f,0x03,0xd5] do |asm|
      asm.dsb     :sy
    end
  end

  def test_DVP_SYS
    # DVP  RCTX, <Xt>
    # SYS #3, C7, C3, #5, <Xt>
    assert_bytes f("a3 73 0b d5") do |asm|
      asm.dvp :rctx, x3
    end
  end

  def test_EON
    # EON  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # EON  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    assert_bytes [0x41,0x00,0x23,0x4a] do |asm|
      asm.eon w1, w2, w3
    end
    assert_bytes [0x41,0x00,0x23,0xca] do |asm|
      asm.eon x1, x2, x3
    end
    assert_bytes [0x41,0x10,0x23,0x4a] do |asm|
      asm.eon w1, w2, w3, lsl(4)
    end
    assert_bytes [0x41,0x10,0x23,0xca] do |asm|
      asm.eon x1, x2, x3, lsl(4)
    end
    assert_bytes [0x41,0x10,0x63,0x4a] do |asm|
      asm.eon w1, w2, w3, lsr(4)
    end
    assert_bytes [0x41,0x10,0x63,0xca] do |asm|
      asm.eon x1, x2, x3, lsr(4)
    end
    assert_bytes [0x41,0x10,0xa3,0x4a] do |asm|
      asm.eon w1, w2, w3, asr(4)
    end
    assert_bytes [0x41,0x10,0xa3,0xca] do |asm|
      asm.eon x1, x2, x3, asr(4)
    end
    assert_bytes [0x41,0x10,0xe3,0x4a] do |asm|
      asm.eon w1, w2, w3, ror(4)
    end
    assert_bytes [0x41,0x10,0xe3,0xca] do |asm|
      asm.eon x1, x2, x3, ror(4)
    end
  end

  def test_ands_32
    assert_bytes f("41 00 12 72") do |asm|
      asm.ands w1, w2, 0x4000
    end
  end

  def test_EOR_all
    # EOR  <Wd|WSP>, <Wn>, #<imm>
    # EOR  <Xd|SP>, <Xn>, #<imm>
    assert_bytes [0x41,0x00,0x12,0x52] do |asm|
      asm.eor w1, w2, 0x4000
    end
    assert_bytes [0x41,0x00,0x71,0xd2] do |asm|
      asm.eor x1, x2, 0x8000
    end
    assert_bytes [0x41,0x00,0x03,0x4a] do |asm|
      asm.eor w1, w2, w3
    end
    assert_bytes [0x41,0x00,0x03,0xca] do |asm|
      asm.eor x1, x2, x3
    end
    assert_bytes [0x41,0x14,0x03,0x4a] do |asm|
      asm.eor w1, w2, w3, lsl(5)
    end
    assert_bytes [0x41,0x14,0x03,0xca] do |asm|
      asm.eor x1, x2, x3, lsl(5)
    end
    assert_bytes [0x41,0x14,0x43,0x4a] do |asm|
      asm.eor w1, w2, w3, lsr(5)
    end
    assert_bytes [0x41,0x14,0x43,0xca] do |asm|
      asm.eor x1, x2, x3, lsr(5)
    end
    assert_bytes [0x41,0x14,0x83,0x4a] do |asm|
      asm.eor w1, w2, w3, asr(5)
    end
    assert_bytes [0x41,0x14,0x83,0xca] do |asm|
      asm.eor x1, x2, x3, asr(5)
    end
    assert_bytes [0x41,0x14,0xc3,0x4a] do |asm|
      asm.eor w1, w2, w3, ror(5)
    end
    assert_bytes [0x41,0x14,0xc3,0xca] do |asm|
      asm.eor x1, x2, x3, ror(5)
    end
    assert_bytes [0xc3,0xc8,0x03,0x52] do |asm|
      asm.eor      w3, w6, 0xe0e0e0e0
    end
    assert_bytes [0xff,0xc7,0x00,0x52] do |asm|
      asm.eor      wsp, wzr, 0x3030303
    end
    assert_bytes [0x30,0xc6,0x01,0x52] do |asm|
      asm.eor      w16, w17, 0x81818181
    end
    assert_bytes [0xa3,0x84,0x66,0xd2] do |asm|
      asm.eor      x3, x5, 0xffffffffc000000
    end
    assert_bytes [0xc3,0xc8,0x03,0xd2] do |asm|
      asm.eor      x3, x6, 0xe0e0e0e0e0e0e0e0
    end
    assert_bytes [0xff,0xc7,0x00,0xd2] do |asm|
      asm.eor      sp, xzr, 0x303030303030303
    end
    assert_bytes [0x30,0xc6,0x01,0xd2] do |asm|
      asm.eor      x16, x17, 0x8181818181818181
    end
    assert_bytes [0x30,0x76,0x1d,0x52] do |asm|
      asm.eor	w16, w17, 0xfffffff9
    end
  end

  def test_ERET
    # ERET
    assert_bytes [0xe0,0x03,0x9f,0xd6] do |asm|
      asm.eret
    end
  end

  def test_ERETA
    # ERETAA
    # ERETAB
    assert_bytes f("ff 0b 9f d6") do |asm|
      asm.eretaa
    end
    assert_bytes f("ff 0f 9f d6") do |asm|
      asm.eretab
    end
  end

  def test_ESB
    # ESB
    assert_bytes [0x1f,0x22,0x03,0xd5] do |asm|
      asm.esb
    end
  end

  def test_EXTR
    # EXTR  <Wd>, <Wn>, <Wm>, #<lsb>
    # EXTR  <Xd>, <Xn>, <Xm>, #<lsb>
    assert_bytes [0x41,0x3c,0x83,0x13] do |asm|
      asm.extr w1, w2, w3, 15
    end
    assert_bytes [0x62,0x04,0xc4,0x93] do |asm|
      asm.extr x2, x3, x4, 1
    end
    assert_bytes [0xa3,0x00,0x87,0x13] do |asm|
      asm.extr     w3, w5, w7, 0
    end
    assert_bytes [0xab,0x7d,0x91,0x13] do |asm|
      asm.extr     w11, w13, w17, 31
    end
    assert_bytes [0xa3,0x3c,0xc7,0x93] do |asm|
      asm.extr     x3, x5, x7, 15
    end
    assert_bytes [0xab,0xfd,0xd1,0x93] do |asm|
      asm.extr     x11, x13, x17, 63
    end
  end

  def test_GMI
    # GMI  <Xd>, <Xn|SP>, <Xm>
    assert_bytes [0x62, 0x14, 0xc4, 0x9a] do |asm|
      asm.gmi x2, x3, x4
    end
    assert_bytes [226, 23, 196, 154] do |asm|
      asm.gmi x2, sp, x4
    end
  end

  def test_HINT
    # HINT  #<imm>
    assert_bytes [0xff,0x2f,0x03,0xd5] do |asm|
      asm.hint 0x7f
    end
  end

  def test_HLT
    # HLT  #<imm>
    assert_bytes [0x60,0x0f,0x40,0xd4] do |asm|
      asm.hlt 0x7b
    end
  end

  def test_HVC
    # HVC  #<imm>
    assert_bytes [34, 0, 0, 212] do |asm|
      asm.hvc 0x1
    end
  end

  def test_IC_SYS
    # IC  <ic_op>{, <Xt>}
    # SYS #<op1>, C7, <Cm>, #<op2>{, <Xt>}

    assert_bytes [0x1f,0x71,0x08,0xd5] do |asm|
      asm.ic :ialluis
    end
    assert_bytes [0x1f,0x75,0x08,0xd5] do |asm|
      asm.ic :iallu
    end
    assert_bytes [0x20,0x75,0x0b,0xd5] do |asm|
      asm.ic :ivau, x0
    end
    assert_bytes [0x1f,0x71,0x08,0xd5] do |asm|
      asm.ic      :ialluis
    end
    assert_bytes [0x1f,0x75,0x08,0xd5] do |asm|
      asm.ic      :iallu
    end
    assert_bytes [0x29,0x75,0x0b,0xd5] do |asm|
      asm.ic      :ivau, x9
    end
  end

  def test_IRG
    # IRG  <Xd|SP>, <Xn|SP>{, <Xm>}
    assert_bytes [97, 16, 223, 154] do |asm|
      asm.irg x1, x3, xzr
    end
    assert_bytes [97, 16, 223, 154] do |asm|
      asm.irg x1, x3
    end
    assert_bytes [225, 19, 223, 154] do |asm|
      asm.irg x1, sp
    end
  end

  def test_ISB
    # ISB  {<option>|#<imm>}
    assert_bytes [0xdf,0x3f,0x03,0xd5] do |asm|
      asm.isb
    end
    assert_bytes [0xdf,0x3c,0x03,0xd5] do |asm|
      asm.isb     12
    end
  end

  def test_LD64B
    skip "Fixme!"
    # LD64B  <Xt>, [<Xn|SP> {,#0}]
  end

  def test_LDADD
    # LDADD  <Ws>, <Wt>, [<Xn|SP>]
    # LDADD  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0x20,0xb8] do |asm|
      asm.ldadd w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0x22,0xb8] do |asm|
      asm.ldadd w2, w3, [sp]
    end
    assert_bytes [0x41,0x00,0x20,0xf8] do |asm|
      asm.ldadd x0, x1, [x2]
    end
    assert_bytes [0xe3,0x03,0x22,0xf8] do |asm|
      asm.ldadd x2, x3, [sp]
    end
    # LDADDA  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDA  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0xa0,0xf8] do |asm|
      asm.ldadda     x0, x1, [x2]
    end
    assert_bytes [0x41,0x00,0xa0,0xb8] do |asm|
      asm.ldadda w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0xa2,0xb8] do |asm|
      asm.ldadda w2, w3, [sp]
    end
    assert_bytes [0x41,0x00,0xa0,0xf8] do |asm|
      asm.ldadda x0, x1, [x2]
    end
    assert_bytes [0xe3,0x03,0xa2,0xf8] do |asm|
      asm.ldadda x2, x3, [sp]
    end
    # LDADDAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDAL  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0xe0,0xb8] do |asm|
      asm.ldaddal w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0xe2,0xb8] do |asm|
      asm.ldaddal w2, w3, [sp]
    end
    assert_bytes [0x41,0x00,0xe0,0xf8] do |asm|
      asm.ldaddal x0, x1, [x2]
    end
    assert_bytes [0xe3,0x03,0xe2,0xf8] do |asm|
      asm.ldaddal x2, x3, [sp]
    end
    # LDADDL  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDL  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0x60,0xb8] do |asm|
      asm.ldaddl w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0x62,0xb8] do |asm|
      asm.ldaddl w2, w3, [sp]
    end
    assert_bytes [0x41,0x00,0x60,0xf8] do |asm|
      asm.ldaddl x0, x1, [x2]
    end
    assert_bytes [0xe3,0x03,0x62,0xf8] do |asm|
      asm.ldaddl x2, x3, [sp]
    end
  end

  def test_LDADDB
    # LDADDAB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0xa0,0x38] do |asm|
      asm.ldaddab w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0xa2,0x38] do |asm|
      asm.ldaddab w2, w3, [sp]
    end
    # LDADDALB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0xe0,0x38] do |asm|
      asm.ldaddalb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0xe2,0x38] do |asm|
      asm.ldaddalb w2, w3, [sp]
    end
    # LDADDB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0x20,0x38] do |asm|
      asm.ldaddb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0x22,0x38] do |asm|
      asm.ldaddb w2, w3, [sp]
    end
    # LDADDLB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0x60,0x38] do |asm|
      asm.ldaddlb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0x62,0x38] do |asm|
      asm.ldaddlb w2, w3, [sp]
    end
  end

  def test_LDADDH
    # LDADDAH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0xa0,0x78] do |asm|
      asm.ldaddah w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0xa2,0x78] do |asm|
      asm.ldaddah w2, w3, [sp]
    end
    # LDADDALH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0xe0,0x78] do |asm|
      asm.ldaddalh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0xe2,0x78] do |asm|
      asm.ldaddalh w2, w3, [sp]
    end
    # LDADDH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0x20,0x78] do |asm|
      asm.ldaddh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0x22,0x78] do |asm|
      asm.ldaddh w2, w3, [sp]
    end
    # LDADDLH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x00,0x60,0x78] do |asm|
      asm.ldaddlh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x03,0x62,0x78] do |asm|
      asm.ldaddlh w2, w3, [sp]
    end
  end

  def test_LDAPR
    # LDAPR  <Wt>, [<Xn|SP> {,#0}]
    # ldapr w2, [x2]
    assert_bytes [0x42, 0xc0, 0xbf, 0xb8] do |asm|
      asm.ldapr w2, [x2]
    end
    # LDAPR  <Xt>, [<Xn|SP> {,#0}]
    # ldapr x2, [x2]
    assert_bytes [0x42, 0xc0, 0xbf, 0xf8] do |asm|
      asm.ldapr x2, [x2]
    end
    # ldapr x2, [sp]
    assert_bytes [0xe2, 0xc3, 0xbf, 0xf8] do |asm|
      asm.ldapr x2, [sp]
    end
  end

  def test_LDAPRB
    # LDAPRB  <Wt>, [<Xn|SP> {,#0}]
    # ldaprb w1, [x1]
    assert_bytes [0x21, 0xc0, 0xbf, 0x38] do |asm|
      asm.ldaprb w1, [x1]
    end
    # ldaprb w1, [sp]
    assert_bytes [0xe1, 0xc3, 0xbf, 0x38] do |asm|
      asm.ldaprb w1, [sp]
    end
  end

  def test_LDAPRH
    # LDAPRH  <Wt>, [<Xn|SP> {,#0}]
    # ldaprh w1, [x1]
    assert_bytes [0x21, 0xc0, 0xbf, 0x78] do |asm|
      asm.ldaprh w1, [x1]
    end
    # ldaprh w2, [sp]
    assert_bytes [0xe2, 0xc3, 0xbf, 0x78] do |asm|
      asm.ldaprh w2, [sp]
    end
  end

  def test_LDAPUR_gen
    # LDAPUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # ldapur w1, [x1]
    assert_bytes [0x21, 00, 0x40, 0x99] do |asm|
      asm.ldapur w1, [x1]
    end
    # ldapur w1, [x1, 123]
    assert_bytes [0x21, 0xb0, 0x47, 0x99] do |asm|
      asm.ldapur w1, [x1, 123]
    end
    # LDAPUR  <Xt>, [<Xn|SP>{, #<simm>}]
    # ldapur x1, [x1]
    assert_bytes [0x21, 00, 0x40, 0xd9] do |asm|
      asm.ldapur x1, [x1]
    end
    # ldapur x2, [x1, -200]
    assert_bytes [0x22, 0x80, 0x53, 0xd9] do |asm|
      asm.ldapur x2, [x1, -200]
    end
    # ldapur x2, [sp, 200]
    assert_bytes [0xe2, 0x83, 0x4c, 0xd9] do |asm|
      asm.ldapur x2, [sp, 200]
    end
  end

  def test_LDAPURB
    # LDAPURB  <Wt>, [<Xn|SP>{, #<simm>}]
    # ldapurb w1, [x1]
    assert_bytes [0x21, 00, 0x40, 0x19] do |asm|
      asm.ldapurb w1, [x1]
    end
    # ldapurb w2, [sp]
    assert_bytes [0xe2, 0x3, 0x40, 0x19] do |asm|
      asm.ldapurb w2, [sp]
    end
    # ldapurb w2, [sp, 22]
    assert_bytes [0xe2, 0x63, 0x41, 0x19] do |asm|
      asm.ldapurb w2, [sp, 22]
    end
  end

  def test_LDAPURH
    # LDAPURH  <Wt>, [<Xn|SP>{, #<simm>}]
    # ldapurh w1, [x1]
    assert_bytes [0x21, 00, 0x40, 0x59] do |asm|
      asm.ldapurh w1, [x1]
    end
    # ldapurh w3, [sp]
    assert_bytes [0xe3, 0x3, 0x40, 0x59] do |asm|
      asm.ldapurh w3, [sp]
    end
    # ldapurh w2, [sp, -12]
    assert_bytes [0xe2, 0x43, 0x5f, 0x59] do |asm|
      asm.ldapurh w2, [sp, -12]
    end
  end

  def test_LDAPURSB
    # LDAPURSB  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPURSB  <Xt>, [<Xn|SP>{, #<simm>}]
    # ldapursb  w1, [x2]
    assert_bytes [0x41, 00, 0xc0, 0x19] do |asm|
      asm.ldapursb  w1, [x2]
    end
    # ldapursb  w1, [x2, 123]
    assert_bytes [0x41, 0xb0, 0xc7, 0x19] do |asm|
      asm.ldapursb  w1, [x2, 123]
    end
    # ldapursb  x2, [sp, 123]
    assert_bytes [0xe2, 0xb3, 0x87, 0x19] do |asm|
      asm.ldapursb  x2, [sp, 123]
    end
  end

  def test_LDAPURSH
    # LDAPURSH  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPURSH  <Xt>, [<Xn|SP>{, #<simm>}]
    # ldapursh  w1, [x3]
    assert_bytes [0x61, 00, 0xc0, 0x59] do |asm|
      asm.ldapursh  w1, [x3]
    end
    # ldapursh  w1, [x3, 123]
    assert_bytes [0x61, 0xb0, 0xc7, 0x59] do |asm|
      asm.ldapursh  w1, [x3, 123]
    end
    # ldapursh  x1, [x3, 123]
    assert_bytes [0x61, 0xb0, 0x87, 0x59] do |asm|
      asm.ldapursh  x1, [x3, 123]
    end
    # ldapursh  x1, [sp, 123]
    assert_bytes [0xe1, 0xb3, 0x87, 0x59] do |asm|
      asm.ldapursh  x1, [sp, 123]
    end
  end

  def test_LDAPURSW
    # LDAPURSW  <Xt>, [<Xn|SP>{, #<simm>}]
    # ldapursw  x3, [x5]
    assert_bytes [0xa3, 00, 0x80, 0x99] do |asm|
      asm.ldapursw  x3, [x5]
    end
    # ldapursw  x3, [x5, 123]
    assert_bytes [0xa3, 0xb0, 0x87, 0x99] do |asm|
      asm.ldapursw  x3, [x5, 123]
    end
    # ldapursw  x3, [sp, 123]
    assert_bytes [0xe3, 0xb3, 0x87, 0x99] do |asm|
      asm.ldapursw  x3, [sp, 123]
    end
  end

  def test_LDAR
    # LDAR  <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0xe4,0xff,0xdf,0x88] do |asm|
      asm.ldar   w4, [sp]
    end
    assert_bytes [0xe4,0xff,0xdf,0xc8] do |asm|
      asm.ldar   x4, [sp]
    end
    assert_bytes [0x3f,0xfc,0xdf,0x88] do |asm|
      asm.ldar     wzr, [x1]
    end
    assert_bytes [0x41,0xfc,0xdf,0xc8] do |asm|
      asm.ldar     x1, [x2]
    end
    # LDAR  <Xt>, [<Xn|SP>{,#0}]
  end

  def test_LDARB
    # LDARB  <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0xe4,0xff,0xdf,0x08] do |asm|
      asm.ldarb  w4, [sp]
    end
    assert_bytes [0xfd,0xff,0xdf,0x08] do |asm|
      asm.ldarb    w29, [sp]
    end
  end

  def test_LDARH
    # LDARH  <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0xe4,0xff,0xdf,0x48] do |asm|
      asm.ldarh  w4, [sp]
    end
    assert_bytes [0x1e,0xfc,0xdf,0x48] do |asm|
      asm.ldarh    w30, [x0]
    end
  end

  def test_LDAXP
    # LDAXP  <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    assert_bytes [0x22,0x98,0x7f,0x88] do |asm|
      asm.ldaxp   w2, w6, [x1]
    end
    assert_bytes [0x22,0x98,0x7f,0xc8] do |asm|
      asm.ldaxp   x2, x6, [x1]
    end
    assert_bytes [0xfa,0xff,0x7f,0x88] do |asm|
      asm.ldaxp    w26, wzr, [sp]
    end
    assert_bytes [0xdb,0xf3,0x7f,0xc8] do |asm|
      asm.ldaxp    x27, x28, [x30]
    end
    # LDAXP  <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
  end

  def test_LDAXR
    # LDAXR  <Wt>, [<Xn|SP>{,#0}]
    # LDAXR  <Xt>, [<Xn|SP>{,#0}]
    assert_bytes [0x82,0xfc,0x5f,0x88] do |asm|
      asm.ldaxr   w2, [x4]
    end
    assert_bytes [0x82,0xfc,0x5f,0xc8] do |asm|
      asm.ldaxr   x2, [x4]
    end
    assert_bytes [0xdf,0xfe,0x5f,0x88] do |asm|
      asm.ldaxr    wzr, [x22]
    end
    assert_bytes [0xf5,0xfe,0x5f,0xc8] do |asm|
      asm.ldaxr    x21, [x23]
    end
  end

  def test_LDAXRB
    # LDAXRB  <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x82,0xfc,0x5f,0x08] do |asm|
      asm.ldaxrb  w2, [x4]
    end
    assert_bytes [0xb3,0xfe,0x5f,0x08] do |asm|
      asm.ldaxrb   w19, [x21]
    end
  end

  def test_LDAXRH
    # LDAXRH  <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x82,0xfc,0x5f,0x48] do |asm|
      asm.ldaxrh  w2, [x4]
    end
    assert_bytes [0xf4,0xff,0x5f,0x48] do |asm|
      asm.ldaxrh   w20, [sp]
    end
  end

  def test_LDCLR
    # LDCLR  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRA  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRL  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLR  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0x20,0xb8] do |asm|
      asm.ldclr w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0x22,0xb8] do |asm|
      asm.ldclr w2, w3, [sp]
    end
    assert_bytes [0x41,0x10,0x20,0xf8] do |asm|
      asm.ldclr x0, x1, [x2]
    end
    assert_bytes [0xe3,0x13,0x22,0xf8] do |asm|
      asm.ldclr x2, x3, [sp]
    end
    # LDCLRA  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0xa0,0xb8] do |asm|
      asm.ldclra w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0xa2,0xb8] do |asm|
      asm.ldclra w2, w3, [sp]
    end
    assert_bytes [0x41,0x10,0xa0,0xf8] do |asm|
      asm.ldclra x0, x1, [x2]
    end
    assert_bytes [0xe3,0x13,0xa2,0xf8] do |asm|
      asm.ldclra x2, x3, [sp]
    end
    # LDCLRAL  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0xe0,0xb8] do |asm|
      asm.ldclral w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0xe2,0xb8] do |asm|
      asm.ldclral w2, w3, [sp]
    end
    assert_bytes [0x41,0x10,0xe0,0xf8] do |asm|
      asm.ldclral x0, x1, [x2]
    end
    assert_bytes [0xe3,0x13,0xe2,0xf8] do |asm|
      asm.ldclral x2, x3, [sp]
    end
    # LDCLRL  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0x60,0xf8] do |asm|
      asm.ldclrl     x0, x1, [x2]
    end
    assert_bytes [0x41,0x10,0x60,0xb8] do |asm|
      asm.ldclrl w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0x62,0xb8] do |asm|
      asm.ldclrl w2, w3, [sp]
    end
    assert_bytes [0x41,0x10,0x60,0xf8] do |asm|
      asm.ldclrl x0, x1, [x2]
    end
    assert_bytes [0xe3,0x13,0x62,0xf8] do |asm|
      asm.ldclrl x2, x3, [sp]
    end
  end

  def test_LDCLRB
    # LDCLRAB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0xa0,0x38] do |asm|
      asm.ldclrab w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0xa2,0x38] do |asm|
      asm.ldclrab w2, w3, [sp]
    end
    # LDCLRALB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0xe0,0x38] do |asm|
      asm.ldclralb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0xe2,0x38] do |asm|
      asm.ldclralb w2, w3, [sp]
    end
    # LDCLRB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0x20,0x38] do |asm|
      asm.ldclrb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0x22,0x38] do |asm|
      asm.ldclrb w2, w3, [sp]
    end
    # LDCLRLB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0x60,0x38] do |asm|
      asm.ldclrlb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0x62,0x38] do |asm|
      asm.ldclrlb w2, w3, [sp]
    end
  end

  def test_LDCLRH
    # LDCLRAH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0xa0,0x78] do |asm|
      asm.ldclrah w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0xa2,0x78] do |asm|
      asm.ldclrah w2, w3, [sp]
    end
    # LDCLRALH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0xe0,0x78] do |asm|
      asm.ldclralh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0xe2,0x78] do |asm|
      asm.ldclralh w2, w3, [sp]
    end
    # LDCLRH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0x20,0x78] do |asm|
      asm.ldclrh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0x22,0x78] do |asm|
      asm.ldclrh w2, w3, [sp]
    end
    # LDCLRLH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x10,0x60,0x78] do |asm|
      asm.ldclrlh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x13,0x62,0x78] do |asm|
      asm.ldclrlh w2, w3, [sp]
    end
  end

  def test_LDEOR
    # LDEOR  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORA  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORL  <Ws>, <Wt>, [<Xn|SP>]
    # LDEOR  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0x20,0xb8] do |asm|
      asm.ldeor w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0x22,0xb8] do |asm|
      asm.ldeor w2, w3, [sp]
    end
    assert_bytes [0x41,0x20,0x20,0xf8] do |asm|
      asm.ldeor x0, x1, [x2]
    end
    assert_bytes [0xe3,0x23,0x22,0xf8] do |asm|
      asm.ldeor x2, x3, [sp]
    end
    # LDEORA  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0xa0,0xb8] do |asm|
      asm.ldeora w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0xa2,0xb8] do |asm|
      asm.ldeora w2, w3, [sp]
    end
    assert_bytes [0x41,0x20,0xa0,0xf8] do |asm|
      asm.ldeora x0, x1, [x2]
    end
    assert_bytes [0xe3,0x23,0xa2,0xf8] do |asm|
      asm.ldeora x2, x3, [sp]
    end
    # LDEORAL  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0xe0,0xf8] do |asm|
      asm.ldeoral    x0, x1, [x2]
    end
    assert_bytes [0x41,0x20,0xe0,0xb8] do |asm|
      asm.ldeoral w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0xe2,0xb8] do |asm|
      asm.ldeoral w2, w3, [sp]
    end
    assert_bytes [0x41,0x20,0xe0,0xf8] do |asm|
      asm.ldeoral x0, x1, [x2]
    end
    assert_bytes [0xe3,0x23,0xe2,0xf8] do |asm|
      asm.ldeoral x2, x3, [sp]
    end
    # LDEORL  <Xs>, <Xt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0x60,0xb8] do |asm|
      asm.ldeorl w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0x62,0xb8] do |asm|
      asm.ldeorl w2, w3, [sp]
    end
    assert_bytes [0x41,0x20,0x60,0xf8] do |asm|
      asm.ldeorl x0, x1, [x2]
    end
    assert_bytes [0xe3,0x23,0x62,0xf8] do |asm|
      asm.ldeorl x2, x3, [sp]
    end
  end

  def test_LDEORB
    # LDEORAB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0xa0,0x38] do |asm|
      asm.ldeorab w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0xa2,0x38] do |asm|
      asm.ldeorab w2, w3, [sp]
    end
    # LDEORALB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0xe0,0x38] do |asm|
      asm.ldeoralb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0xe2,0x38] do |asm|
      asm.ldeoralb w2, w3, [sp]
    end
    # LDEORB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0x20,0x38] do |asm|
      asm.ldeorb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0x22,0x38] do |asm|
      asm.ldeorb w2, w3, [sp]
    end
    # LDEORLB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0x60,0x38] do |asm|
      asm.ldeorlb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0x62,0x38] do |asm|
      asm.ldeorlb w2, w3, [sp]
    end
  end

  def test_LDEORH
    # LDEORAH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0xa0,0x78] do |asm|
      asm.ldeorah w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0xa2,0x78] do |asm|
      asm.ldeorah w2, w3, [sp]
    end
    # LDEORALH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0xe0,0x78] do |asm|
      asm.ldeoralh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0xe2,0x78] do |asm|
      asm.ldeoralh w2, w3, [sp]
    end
    # LDEORH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0x20,0x78] do |asm|
      asm.ldeorh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0x22,0x78] do |asm|
      asm.ldeorh w2, w3, [sp]
    end
    # LDEORLH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x20,0x60,0x78] do |asm|
      asm.ldeorlh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x23,0x62,0x78] do |asm|
      asm.ldeorlh w2, w3, [sp]
    end
  end

  def test_LDG
    skip "Fixme!"
    # LDG  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDGM
    skip "Fixme!"
    # LDGM  <Xt>, [<Xn|SP>]
  end

  def test_LDLAR
    # LDLAR  <Wt>, [<Xn|SP>{,#0}]
    # LDLAR  <Xt>, [<Xn|SP>{,#0}]
    assert_bytes [0x20,0x7c,0xdf,0x88] do |asm|
      asm.ldlar  w0, [x1]
    end
    assert_bytes [0x20,0x7c,0xdf,0xc8] do |asm|
      asm.ldlar  x0, [x1]
    end
  end

  def test_LDLARB
    # LDLARB  <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x20,0x7c,0xdf,0x08] do |asm|
      asm.ldlarb w0, [x1]
    end
  end

  def test_LDLARH
    # LDLARH  <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x20,0x7c,0xdf,0x48] do |asm|
      asm.ldlarh w0, [x1]
    end
  end

  def test_LDNP_gen
    # LDNP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # LDNP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    assert_bytes [0xe3,0x09,0x42,0x28] do |asm|
      asm.ldnp  w3, w2, [x15, 16]
    end
    assert_bytes [0xe4,0x27,0x7f,0xa8] do |asm|
      asm.ldnp  x4, x9, [sp, -16]
    end
    assert_bytes [0xe3,0x09,0x42,0x28] do |asm|
      asm.ldnp  w3, w2, [x15, 16]
    end
    assert_bytes [0xe3,0x17,0x40,0x28] do |asm|
      asm.ldnp      w3, w5, [sp]
    end
    assert_bytes [0xe2,0x7f,0x60,0x28] do |asm|
      asm.ldnp      w2, wzr, [sp, -256]
    end
    assert_bytes [0xe9,0xab,0x40,0x28] do |asm|
      asm.ldnp      w9, w10, [sp, 4]
    end
    assert_bytes [0x55,0xf4,0x5f,0xa8] do |asm|
      asm.ldnp      x21, x29, [x2, 504]
    end
    assert_bytes [0x76,0x5c,0x60,0xa8] do |asm|
      asm.ldnp      x22, x23, [x3, -512]
    end
    assert_bytes [0x98,0xe4,0x40,0xa8] do |asm|
      asm.ldnp      x24, x25, [x4, 8]
    end
  end

  def test_LDP_gen
    # LDP  <Wt1>, <Wt2>, [<Xn|SP>], #<imm>
    # LDP  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # LDP  <Wt1>, <Wt2>, [<Xn|SP>, #<imm>]!
    # LDP  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # LDP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # LDP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    assert_bytes [0xe3,0x09,0x42,0x29] do |asm|
      asm.ldp    w3, w2, [x15, 16]
    end
    assert_bytes [0xe4,0x27,0x7f,0xa9] do |asm|
      asm.ldp    x4, x9, [sp, -16]
    end
    assert_bytes [0xe3,0x09,0xc2,0x29] do |asm|
      asm.ldp  w3, w2, [x15, 16], :!
    end
    assert_bytes [0xe4,0x27,0xff,0xa9] do |asm|
      asm.ldp  x4, x9, [sp, -16], :!
    end
    assert_bytes [0xe3,0x09,0xc2,0x28] do |asm|
      asm.ldp  w3, w2, [x15], 16
    end
    assert_bytes [0xe4,0x27,0xff,0xa8] do |asm|
      asm.ldp  x4, x9, [sp], -16
    end
    assert_bytes [0xe3,0x17,0x40,0x29] do |asm|
      asm.ldp      w3, w5, [sp]
    end
    assert_bytes [0xe2,0x7f,0x60,0x29] do |asm|
      asm.ldp      w2, wzr, [sp, -256]
    end
    assert_bytes [0xe9,0xab,0x40,0x29] do |asm|
      asm.ldp      w9, w10, [sp, 4]
    end
    assert_bytes [0x55,0xf4,0x5f,0xa9] do |asm|
      asm.ldp      x21, x29, [x2, 504]
    end
    assert_bytes [0x76,0x5c,0x60,0xa9] do |asm|
      asm.ldp      x22, x23, [x3, -512]
    end
    assert_bytes [0x98,0xe4,0x40,0xa9] do |asm|
      asm.ldp      x24, x25, [x4, 8]
    end
    assert_bytes [0xe3,0x17,0xc0,0x28] do |asm|
      asm.ldp      w3, w5, [sp], 0
    end
    assert_bytes [0xe2,0x7f,0xe0,0x28] do |asm|
      asm.ldp      w2, wzr, [sp], -256
    end
    assert_bytes [0xe9,0xab,0xc0,0x28] do |asm|
      asm.ldp      w9, w10, [sp], 4
    end
    assert_bytes [0x55,0xf4,0xdf,0xa8] do |asm|
      asm.ldp      x21, x29, [x2], 504
    end
    assert_bytes [0x76,0x5c,0xe0,0xa8] do |asm|
      asm.ldp      x22, x23, [x3], -512
    end
    assert_bytes [0x98,0xe4,0xc0,0xa8] do |asm|
      asm.ldp      x24, x25, [x4], 8
    end
    assert_bytes [0xe3,0x17,0xc0,0x29] do |asm|
      asm.ldp      w3, w5, [sp, 0], :!
    end
    assert_bytes [0xe2,0x7f,0xe0,0x29] do |asm|
      asm.ldp      w2, wzr, [sp, -256], :!
    end
    assert_bytes [0xe9,0xab,0xc0,0x29] do |asm|
      asm.ldp      w9, w10, [sp, 4], :!
    end
    assert_bytes [0x55,0xf4,0xdf,0xa9] do |asm|
      asm.ldp      x21, x29, [x2, 504], :!
    end
    assert_bytes [0x76,0x5c,0xe0,0xa9] do |asm|
      asm.ldp      x22, x23, [x3, -512], :!
    end
    assert_bytes [0x98,0xe4,0xc0,0xa9] do |asm|
      asm.ldp      x24, x25, [x4, 8], :!
    end
  end

  def test_LDPSW
    # LDPSW  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # LDPSW  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # LDPSW  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    assert_bytes [0xc2,0x0d,0x42,0x69] do |asm|
      asm.ldpsw  x2, x3, [x14, 16]
    end
    assert_bytes [0xe2,0x0f,0x7e,0x69] do |asm|
      asm.ldpsw  x2, x3, [sp, -16]
    end
    assert_bytes [0xc2,0x0d,0xc2,0x69] do |asm|
      asm.ldpsw	x2, x3, [x14, 16], :!
    end
    assert_bytes [0xe2,0x0f,0xfe,0x69] do |asm|
      asm.ldpsw	x2, x3, [sp, -16], :!
    end
    assert_bytes [0xc2,0x0d,0xc2,0x68] do |asm|
      asm.ldpsw	x2, x3, [x14], 16
    end
    assert_bytes [0xe2,0x0f,0xfe,0x68] do |asm|
      asm.ldpsw	x2, x3, [sp], -16
    end
    assert_bytes [0xe9,0xab,0x40,0x69] do |asm|
      asm.ldpsw    x9, x10, [sp, 4]
    end
    assert_bytes [0x49,0x28,0x60,0x69] do |asm|
      asm.ldpsw    x9, x10, [x2, -256]
    end
    assert_bytes [0xf4,0xfb,0x5f,0x69] do |asm|
      asm.ldpsw    x20, x30, [sp, 252]
    end
    assert_bytes [0xe9,0xab,0xc0,0x68] do |asm|
      asm.ldpsw    x9, x10, [sp], 4
    end
    assert_bytes [0x49,0x28,0xe0,0x68] do |asm|
      asm.ldpsw    x9, x10, [x2], -256
    end
    assert_bytes [0xf4,0xfb,0xdf,0x68] do |asm|
      asm.ldpsw    x20, x30, [sp], 252
    end
    assert_bytes [0xe9,0xab,0xc0,0x69] do |asm|
      asm.ldpsw    x9, x10, [sp, 4], :!
    end
    assert_bytes [0x49,0x28,0xe0,0x69] do |asm|
      asm.ldpsw    x9, x10, [x2, -256], :!
    end
    assert_bytes [0xf4,0xfb,0xdf,0x69] do |asm|
      asm.ldpsw    x20, x30, [sp, 252], :!
    end
  end

  def test_LDR_imm_gen
    # LDR  <Wt>, [<Xn|SP>], #<simm>
    # LDR  <Xt>, [<Xn|SP>], #<simm>
    # LDR  <Wt>, [<Xn|SP>, #<simm>]!
    # LDR  <Xt>, [<Xn|SP>, #<simm>]!
    # LDR  <Wt>, [<Xn|SP>{, #<pimm>}]
    # LDR  <Xt>, [<Xn|SP>{, #<pimm>}]
    assert_bytes [0x85,0x14,0x40,0xb9] do |asm|
      asm.ldr    w5, [x4, 20]
    end
    assert_bytes [0x64,0x00,0x40,0xf9] do |asm|
      asm.ldr    x4, [x3]
    end
    assert_bytes [0xe2,0x13,0x40,0xf9] do |asm|
      asm.ldr    x2, [sp, 32]
    end
    assert_bytes [0xfd,0x8c,0x40,0xf8] do |asm|
      asm.ldr  x29, [x7, 8], :!
    end
    assert_bytes [0xfe,0x8c,0x40,0xf8] do |asm|
      asm.ldr  x30, [x7, 8], :!
    end
    assert_bytes [0xfd,0x84,0x40,0xf8] do |asm|
      asm.ldr x29, [x7], 8
    end
    assert_bytes [0xfe,0x84,0x40,0xf8] do |asm|
      asm.ldr x30, [x7], 8
    end
    assert_bytes [0x00,0x68,0x60,0xb8] do |asm|
      asm.ldr  w0, [x0, x0]
    end
    assert_bytes [0x00,0x78,0x60,0xb8] do |asm|
      asm.ldr  w0, [x0, x0, lsl(2)]
    end
    assert_bytes [0x00,0x68,0x60,0xf8] do |asm|
      asm.ldr  x0, [x0, x0]
    end
    assert_bytes [0x00,0x78,0x60,0xf8] do |asm|
      asm.ldr  x0, [x0, x0, lsl(3)]
    end
    assert_bytes [0x00,0xe8,0x60,0xf8] do |asm|
      asm.ldr  x0, [x0, x0, sxtx]
    end
    assert_bytes [0xe0,0xff,0x7f,0x18] do |asm|
      asm.ldr     w0, 1048572
    end
    assert_bytes [0x0a,0x00,0x80,0x58] do |asm|
      asm.ldr     x10, -1048576
    end
    assert_bytes [0x00,0x00,0x40,0xf9] do |asm|
      asm.ldr      x0, [x0]
    end
    assert_bytes [0xa4,0x03,0x40,0xf9] do |asm|
      asm.ldr      x4, [x29]
    end
    assert_bytes [0x9e,0xfd,0x7f,0xf9] do |asm|
      asm.ldr      x30, [x12, 32760]
    end
    assert_bytes [0xf4,0x07,0x40,0xf9] do |asm|
      asm.ldr      x20, [sp, 8]
    end
    assert_bytes [0xff,0x03,0x40,0xf9] do |asm|
      asm.ldr      xzr, [sp]
    end
    assert_bytes [0xe2,0x03,0x40,0xb9] do |asm|
      asm.ldr      w2, [sp]
    end
    assert_bytes [0xf1,0xff,0x7f,0xb9] do |asm|
      asm.ldr      w17, [sp, 16380]
    end
    assert_bytes [0x4d,0x04,0x40,0xb9] do |asm|
      asm.ldr      w13, [x2, 4]
    end
    assert_bytes [0xe3,0x6b,0x65,0xb8] do |asm|
      asm.ldr      w3, [sp, x5]
    end
    assert_bytes [0xca,0x7b,0x67,0xb8] do |asm|
      asm.ldr      w10, [x30, x7, lsl(2)]
    end
    assert_bytes [0xab,0xeb,0x63,0xb8] do |asm|
      asm.ldr      w11, [x29, x3, sxtx]
    end
    assert_bytes [0x2f,0x4b,0x67,0xb8] do |asm|
      asm.ldr      w15, [x25, w7, uxtw]
    end
    assert_bytes [0x10,0x5b,0x68,0xb8] do |asm|
      asm.ldr      w16, [x24, w8, uxtw(2)]
    end
    assert_bytes [0xd2,0xca,0x6a,0xb8] do |asm|
      asm.ldr      w18, [x22, w10, sxtw]
    end
    assert_bytes [0xe3,0x6b,0x65,0xf8] do |asm|
      asm.ldr      x3, [sp, x5]
    end
    assert_bytes [0x8c,0xeb,0x7f,0xf8] do |asm|
      asm.ldr      x12, [x28, xzr, sxtx]
    end
    assert_bytes [0x6d,0xfb,0x65,0xf8] do |asm|
      asm.ldr      x13, [x27, x5, sxtx(3)]
    end
    assert_bytes [0x2f,0x4b,0x67,0xf8] do |asm|
      asm.ldr      x15, [x25, w7, uxtw]
    end
    assert_bytes [0x10,0x5b,0x68,0xf8] do |asm|
      asm.ldr      x16, [x24, w8, uxtw(3)]
    end
    assert_bytes [0xf1,0xca,0x69,0xf8] do |asm|
      asm.ldr      x17, [x23, w9, sxtw]
    end
    assert_bytes [0xd2,0xca,0x6a,0xf8] do |asm|
      asm.ldr      x18, [x22, w10, sxtw]
    end
    assert_bytes [0xf3,0xf7,0x4f,0xb8] do |asm|
      asm.ldr      w19, [sp], 255
    end
    assert_bytes [0xd4,0x17,0x40,0xb8] do |asm|
      asm.ldr      w20, [x30], 1
    end
    assert_bytes [0x95,0x05,0x50,0xb8] do |asm|
      asm.ldr      w21, [x12], -256
    end
    assert_bytes [0x3f,0xf5,0x4f,0xf8] do |asm|
      asm.ldr      xzr, [x9], 255
    end
    assert_bytes [0x62,0x14,0x40,0xf8] do |asm|
      asm.ldr      x2, [x3], 1
    end
    assert_bytes [0x93,0x05,0x50,0xf8] do |asm|
      asm.ldr      x19, [x12], -256
    end
    assert_bytes [0x83,0x0c,0x40,0xf8] do |asm|
      asm.ldr      x3, [x4, 0], :!
    end
    assert_bytes [0xff,0x0f,0x40,0xf8] do |asm|
      asm.ldr      xzr, [sp, 0], :!
    end
    assert_bytes [0xf3,0xff,0x4f,0xb8] do |asm|
      asm.ldr      w19, [sp, 255], :!
    end
    assert_bytes [0xd4,0x1f,0x40,0xb8] do |asm|
      asm.ldr      w20, [x30, 1], :!
    end
    assert_bytes [0x95,0x0d,0x50,0xb8] do |asm|
      asm.ldr      w21, [x12, -256], :!
    end
    assert_bytes [0x3f,0xfd,0x4f,0xf8] do |asm|
      asm.ldr      xzr, [x9, 255], :!
    end
    assert_bytes [0x62,0x1c,0x40,0xf8] do |asm|
      asm.ldr      x2, [x3, 1], :!
    end
    assert_bytes [0x93,0x0d,0x50,0xf8] do |asm|
      asm.ldr      x19, [x12, -256], :!
    end
  end

  def test_LDR_lit_gen
    # LDR  <Wt>, <label>
    # LDR  <Xt>, <label>
    assert_one_insn "ldr x1, #4" do |asm|
      label = asm.make_label :foo
      asm.ldr x1, label
      asm.put_label label
    end
    assert_one_insn "ldr w1, #4" do |asm|
      label = asm.make_label :foo
      asm.ldr w1, label
      asm.put_label label
    end
  end

  def test_LDRA
    # LDRAA  <Xt>, [<Xn|SP>{, #<simm>}]
    # LDRAA  <Xt>, [<Xn|SP>{, #<simm>}]!
    # ldraa x1, [x2]
    assert_bytes [0x41, 0x4, 0x20, 0xf8] do |asm|
      asm.ldraa x1, [x2]
    end
    # ldraa x1, [x2, #16]
    assert_bytes [0x41, 0x24, 0x20, 0xf8] do |asm|
      asm.ldraa x1, [x2, 16]
    end
    # ldraa x1, [x2, #-16]
    assert_bytes [0x41, 0xe4, 0x7f, 0xf8] do |asm|
      asm.ldraa x1, [x2, -16]
    end
    # ldraa x1, [x2]!
    assert_bytes [0x41, 0xc, 0x20, 0xf8] do |asm|
      asm.ldraa x1, [x2], :!
    end
    # ldraa x1, [x2, 32]!
    assert_bytes [0x41, 0x4c, 0x20, 0xf8] do |asm|
      asm.ldraa x1, [x2, 32], :!
    end
    # ldraa x1, [x2, -32]!
    assert_bytes [0x41, 0xcc, 0x7f, 0xf8] do |asm|
      asm.ldraa x1, [x2, -32], :!
    end
    # LDRAB  <Xt>, [<Xn|SP>{, #<simm>}]
    # LDRAB  <Xt>, [<Xn|SP>{, #<simm>}]!
    # ldrab x1, [x2]
    assert_bytes [0x41, 0x4, 0xa0, 0xf8] do |asm|
      asm.ldrab x1, [x2]
    end
    # ldrab x1, [x2, #16]
    assert_bytes [0x41, 0x24, 0xa0, 0xf8] do |asm|
      asm.ldrab x1, [x2, 16]
    end
    # ldrab x1, [x2, #-16]
    assert_bytes [0x41, 0xe4, 0xff, 0xf8] do |asm|
      asm.ldrab x1, [x2, -16]
    end
    # ldrab x1, [x2]!
    assert_bytes [0x41, 0xc, 0xa0, 0xf8] do |asm|
      asm.ldrab x1, [x2], :!
    end
    # ldrab x1, [x2, #16]!
    assert_bytes [0x41, 0x2c, 0xa0, 0xf8] do |asm|
      asm.ldrab x1, [x2, 16], :!
    end
    # ldrab x1, [x2, #-16]!
    assert_bytes [0x41, 0xec, 0xff, 0xf8] do |asm|
      asm.ldrab x1, [x2, -16], :!
    end
  end

  def test_LDRB_imm
    # LDRB  <Wt>, [<Xn|SP>], #<simm>
    # LDRB  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRB  <Wt>, [<Xn|SP>{, #<pimm>}]
    assert_bytes [0x64,0x00,0x40,0x39] do |asm|
      asm.ldrb   w4, [x3]
    end
    assert_bytes [0x85,0x50,0x40,0x39] do |asm|
      asm.ldrb   w5, [x4, 20]
    end
    assert_bytes [0x7a,0xe4,0x41,0x39] do |asm|
      asm.ldrb     w26, [x3, 121]
    end
    assert_bytes [0x4c,0x00,0x40,0x39] do |asm|
      asm.ldrb     w12, [x2]
    end
    # ldrb w3, [sp, x5]
    assert_bytes [0xe3,0x6b,0x65,0x38] do |asm|
      asm.ldrb     w3, [sp, x5]
    end
    assert_bytes [0x69,0x7b,0x66,0x38] do |asm|
      asm.ldrb     w9, [x27, x6, lsl(0)]
    end
    assert_bytes [0xab,0xeb,0x63,0x38] do |asm|
      asm.ldrb     w11, [x29, x3, sxtx]
    end
    assert_bytes [0x4e,0x4b,0x66,0x38] do |asm|
      asm.ldrb     w14, [x26, w6, uxtw]
    end
    assert_bytes [0xf1,0xca,0x69,0x38] do |asm|
      asm.ldrb     w17, [x23, w9, sxtw]
    end
    assert_bytes [0x49,0xf4,0x4f,0x38] do |asm|
      asm.ldrb     w9, [x2], 255
    end
    assert_bytes [0x6a,0x14,0x40,0x38] do |asm|
      asm.ldrb     w10, [x3], 1
    end
    assert_bytes [0x6a,0x04,0x50,0x38] do |asm|
      asm.ldrb     w10, [x3], -256
    end
    assert_bytes [0x49,0xfc,0x4f,0x38] do |asm|
      asm.ldrb     w9, [x2, 255], :!
    end
    assert_bytes [0x6a,0x1c,0x40,0x38] do |asm|
      asm.ldrb     w10, [x3, 1], :!
    end
    assert_bytes [0x6a,0x0c,0x50,0x38] do |asm|
      asm.ldrb     w10, [x3, -256], :!
    end
  end

  def test_LDRB_reg
    skip "Fixme!"
    # LDRB  <Wt>, [<Xn|SP>, (<Wm>|<Xm>), <extend> {<amount>}]
    # LDRB  <Wt>, [<Xn|SP>, <Xm>{, LSL <amount>}]
  end

  def test_LDRH_imm
    skip "Fixme!"
    # LDRH  <Wt>, [<Xn|SP>], #<simm>
    # LDRH  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRH  <Wt>, [<Xn|SP>{, #<pimm>}]
  end

  def test_LDRH_reg
    skip "Fixme!"
    # LDRH  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
  end

  def test_LDRSB_imm
    skip "Fixme!"
    # LDRSB  <Wt>, [<Xn|SP>], #<simm>
    # LDRSB  <Xt>, [<Xn|SP>], #<simm>
    # LDRSB  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRSB  <Xt>, [<Xn|SP>, #<simm>]!
    # LDRSB  <Wt>, [<Xn|SP>{, #<pimm>}]
    # LDRSB  <Xt>, [<Xn|SP>{, #<pimm>}]
  end

  def test_LDRSB_reg
    skip "Fixme!"
    # LDRSB  <Wt>, [<Xn|SP>, (<Wm>|<Xm>), <extend> {<amount>}]
    # LDRSB  <Wt>, [<Xn|SP>, <Xm>{, LSL <amount>}]
    # LDRSB  <Xt>, [<Xn|SP>, (<Wm>|<Xm>), <extend> {<amount>}]
    # LDRSB  <Xt>, [<Xn|SP>, <Xm>{, LSL <amount>}]
  end

  def test_LDRSH_imm
    skip "Fixme!"
    # LDRSH  <Wt>, [<Xn|SP>], #<simm>
    # LDRSH  <Xt>, [<Xn|SP>], #<simm>
    # LDRSH  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRSH  <Xt>, [<Xn|SP>, #<simm>]!
    # LDRSH  <Wt>, [<Xn|SP>{, #<pimm>}]
    # LDRSH  <Xt>, [<Xn|SP>{, #<pimm>}]
  end

  def test_LDRSH_reg
    skip "Fixme!"
    # LDRSH  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    # LDRSH  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
  end

  def test_LDRSW_imm
    skip "Fixme!"
    # LDRSW  <Xt>, [<Xn|SP>], #<simm>
    # LDRSW  <Xt>, [<Xn|SP>, #<simm>]!
    # LDRSW  <Xt>, [<Xn|SP>{, #<pimm>}]
  end

  def test_LDRSW_lit
    skip "Fixme!"
    # LDRSW  <Xt>, <label>
  end

  def test_LDRSW_reg
    skip "Fixme!"
    # LDRSW  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
  end

  def test_LDSET
    skip "Fixme!"
    # LDSET  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETA  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSET  <Xs>, <Xt>, [<Xn|SP>]
    # LDSETA  <Xs>, <Xt>, [<Xn|SP>]
    # LDSETAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDSETL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_LDSETB
    skip "Fixme!"
    # LDSETAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETLB  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDSETH
    skip "Fixme!"
    # LDSETAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETLH  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDSMAX
    skip "Fixme!"
    # LDSMAX  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXA  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAX  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMAXA  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMAXAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMAXL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_LDSMAXB
    skip "Fixme!"
    # LDSMAXAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXLB  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDSMAXH
    skip "Fixme!"
    # LDSMAXAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXLH  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDSMIN
    skip "Fixme!"
    # LDSMIN  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINA  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMIN  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMINA  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMINAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMINL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_LDSMINB
    skip "Fixme!"
    # LDSMINAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINLB  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDSMINH
    skip "Fixme!"
    # LDSMINAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINLH  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDTR
    skip "Fixme!"
    # LDTR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDTR  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDTRB
    skip "Fixme!"
    # LDTRB  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDTRH
    skip "Fixme!"
    # LDTRH  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDTRSB
    skip "Fixme!"
    # LDTRSB  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDTRSB  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDTRSH
    skip "Fixme!"
    # LDTRSH  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDTRSH  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDTRSW
    skip "Fixme!"
    # LDTRSW  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDUMAX
    skip "Fixme!"
    # LDUMAX  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXA  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAX  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMAXA  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMAXAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMAXL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_LDUMAXB
    skip "Fixme!"
    # LDUMAXAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXLB  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDUMAXH
    skip "Fixme!"
    # LDUMAXAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXLH  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDUMIN
    skip "Fixme!"
    # LDUMIN  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINA  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMIN  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMINA  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMINAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMINL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_LDUMINB
    skip "Fixme!"
    # LDUMINAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINLB  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDUMINH
    skip "Fixme!"
    # LDUMINAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINLH  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDUR_gen
    skip "Fixme!"
    # LDUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDUR  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDURB
    skip "Fixme!"
    # LDURB  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDURH
    skip "Fixme!"
    # LDURH  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDURSB
    skip "Fixme!"
    # LDURSB  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDURSB  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDURSH
    skip "Fixme!"
    # LDURSH  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDURSH  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDURSW
    skip "Fixme!"
    # LDURSW  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDXP
    skip "Fixme!"
    # LDXP  <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # LDXP  <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
  end

  def test_LDXR
    # LDXR  <Wt>, [<Xn|SP>{,#0}]
    # LDXR  <Xt>, [<Xn|SP>{,#0}]
    assert_bytes [0xe9,0x7f,0x5f,0x88] do |asm|
      asm.ldxr     w9, [sp]
    end
    assert_bytes [0x6a,0x7d,0x5f,0xc8] do |asm|
      asm.ldxr     x10, [x11]
    end
  end

  def test_LDXRB
    # LDXRB  <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x26,0x7c,0x5f,0x08] do |asm|
      asm.ldxrb  w6, [x1]
    end
    assert_bytes [0x27,0x7d,0x5f,0x08] do |asm|
      asm.ldxrb    w7, [x9]
    end
  end

  def test_LDXRH
    # LDXRH  <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x26,0x7c,0x5f,0x48] do |asm|
      asm.ldxrh  w6, [x1]
    end
    assert_bytes [0x5f,0x7d,0x5f,0x48] do |asm|
      asm.ldxrh    wzr, [x10]
    end
  end

  def test_LSL_LSLV
    # LSL  <Wd>, <Wn>, <Wm>
    # LSLV <Wd>, <Wn>, <Wm>
    # LSL  <Xd>, <Xn>, <Xm>
    # LSL  <Wd>, <Wn>, #<shift>
    # UBFM <Wd>, <Wn>, #(-<shift> MOD 32), #(31-<shift>)
    # LSL  <Xd>, <Xn>, #<shift>
    # UBFM <Xd>, <Xn>, #(-<shift> MOD 64), #(63-<shift>)
    assert_bytes [0x1f,0x00,0x01,0x53] do |asm|
      asm.lsl  wzr, w0, 31
    end
    assert_bytes [0x49,0x01,0x01,0x53] do |asm|
      asm.lsl      w9, w10, 31
    end
    assert_bytes [0xb4,0x02,0x41,0xd3] do |asm|
      asm.lsl      x20, x21, 63
    end
    assert_bytes [0xe1,0x73,0x1d,0x53] do |asm|
      asm.lsl      w1, wzr, 3
    end
    assert_bytes [0x62,0x00,0x41,0xd3] do |asm|
      asm.lsl      x2, x3, 63
    end
    assert_bytes [0x49,0xe9,0x7b,0xd3] do |asm|
      asm.lsl      x9, x10, 5
    end
    assert_bytes [0x8b,0x01,0x01,0x53] do |asm|
      asm.lsl      w11, w12, 31
    end
    assert_bytes [0xcd,0x09,0x03,0x53] do |asm|
      asm.lsl      w13, w14, 29
    end
    assert_bytes [0x8b,0x21,0xcd,0x1a] do |asm|
      asm.lsl	w11, w12, w13
    end
    assert_bytes [0xee,0x21,0xd0,0x9a] do |asm|
      asm.lsl	x14, x15, x16
    end
    assert_bytes [0xe6,0x20,0xc8,0x1a] do |asm|
      asm.lsl	w6, w7, w8
    end
    assert_bytes [0x49,0x21,0xcb,0x9a] do |asm|
      asm.lsl	x9, x10, x11
    end
    # LSLV <Xd>, <Xn>, <Xm>
  end

  def test_LSLV
    # LSLV  <Wd>, <Wn>, <Wm>
    # LSLV  <Xd>, <Xn>, <Xm>
    # lslv  w1, w2, w3
    assert_bytes [0x41, 0x20, 0xc3, 0x1a] do |asm|
      asm.lslv  w1, w2, w3
    end
    # lslv  x1, x2, x3
    assert_bytes [0x41, 0x20, 0xc3, 0x9a] do |asm|
      asm.lslv  x1, x2, x3
    end
  end

  def test_LSR_LSRV
    # LSR  <Wd>, <Wn>, <Wm>
    # LSRV <Wd>, <Wn>, <Wm>
    # LSR  <Xd>, <Xn>, <Xm>
    # LSRV <Xd>, <Xn>, <Xm>
    # LSR  <Wd>, <Wn>, #<shift>
    # UBFM <Wd>, <Wn>, #<shift>, #31
    # LSR  <Xd>, <Xn>, #<shift>
    # UBFM <Xd>, <Xn>, #<shift>, #63
    assert_bytes [0xc5,0xfc,0x4c,0xd3] do |asm|
      asm.lsr      x5, x6, 12
    end
    assert_bytes [0x43,0x7c,0x00,0x53] do |asm|
      asm.lsr      w3, w2, 0
    end
    assert_bytes [0x49,0x7d,0x1f,0x53] do |asm|
      asm.lsr      w9, w10, 31
    end
    assert_bytes [0xb4,0xfe,0x7f,0xd3] do |asm|
      asm.lsr      x20, x21, 63
    end
    assert_bytes [0xff,0x7f,0x03,0x53] do |asm|
      asm.lsr      wzr, wzr, 3
    end
    assert_bytes [0x93,0xfe,0x40,0xd3] do |asm|
      asm.lsr      x19, x20, 0
    end
    assert_bytes [0x49,0x7d,0x00,0x53] do |asm|
      asm.lsr      w9, w10, 0
    end
    assert_bytes [0x62,0xfc,0x7f,0xd3] do |asm|
      asm.lsr     x2, x3, 63
    end
    assert_bytes [0x93,0xfe,0x40,0xd3] do |asm|
      asm.lsr     x19, x20, 0
    end
    assert_bytes [0x49,0xfd,0x45,0xd3] do |asm|
      asm.lsr     x9, x10, 5
    end
    assert_bytes [0x49,0x7d,0x00,0x53] do |asm|
      asm.lsr     w9, w10, 0
    end
    assert_bytes [0x8b,0x7d,0x1f,0x53] do |asm|
      asm.lsr     w11, w12, 31
    end
    assert_bytes [0xcd,0x7d,0x1d,0x53] do |asm|
      asm.lsr     w13, w14, 29
    end
    assert_bytes [0x51,0x26,0xd3,0x1a] do |asm|
      asm.lsr	w17, w18, w19
    end
    assert_bytes [0xb4,0x26,0xd6,0x9a] do |asm|
      asm.lsr	x20, x21, x22
    end
    assert_bytes [0xac,0x25,0xce,0x1a] do |asm|
      asm.lsr	w12, w13, w14
    end
    assert_bytes [0x0f,0x26,0xd1,0x9a] do |asm|
      asm.lsr	x15, x16, x17
    end
  end

  def test_LSRV
    # LSRV  <Wd>, <Wn>, <Wm>
    # LSRV  <Xd>, <Xn>, <Xm>
    # lsrv  w1, w2, w3
    assert_bytes [0x41, 0x24, 0xc3, 0x1a] do |asm|
      asm.lsrv  w1, w2, w3
    end
    # lsrv  x1, x2, x3
    assert_bytes [0x41, 0x24, 0xc3, 0x9a] do |asm|
      asm.lsrv  x1, x2, x3
    end
  end

  def test_MADD
    # MADD  <Wd>, <Wn>, <Wm>, <Wa>
    # MADD  <Xd>, <Xn>, <Xm>, <Xa>
    assert_bytes [0x41,0x10,0x03,0x1b] do |asm|
      asm.madd   w1, w2, w3, w4
    end
    assert_bytes [0x41,0x10,0x03,0x9b] do |asm|
      asm.madd   x1, x2, x3, x4
    end
    assert_bytes [0x61,0x10,0x07,0x1b] do |asm|
      asm.madd     w1, w3, w7, w4
    end
    assert_bytes [0x1f,0x2c,0x09,0x1b] do |asm|
      asm.madd     wzr, w0, w9, w11
    end
    assert_bytes [0xed,0x13,0x04,0x1b] do |asm|
      asm.madd     w13, wzr, w4, w4
    end
    assert_bytes [0xd3,0x77,0x1f,0x1b] do |asm|
      asm.madd     w19, w30, wzr, w29
    end
    assert_bytes [0x61,0x10,0x07,0x9b] do |asm|
      asm.madd     x1, x3, x7, x4
    end
    assert_bytes [0x1f,0x2c,0x09,0x9b] do |asm|
      asm.madd     xzr, x0, x9, x11
    end
    assert_bytes [0xed,0x13,0x04,0x9b] do |asm|
      asm.madd     x13, xzr, x4, x4
    end
    assert_bytes [0xd3,0x77,0x1f,0x9b] do |asm|
      asm.madd     x19, x30, xzr, x29
    end
  end

  def test_MNEG_MSUB
    # MNEG  <Wd>, <Wn>, <Wm>
    # MSUB <Wd>, <Wn>, <Wm>, WZR
    # MNEG  <Xd>, <Xn>, <Xm>
    assert_bytes [0xa4,0xfc,0x06,0x1b] do |asm|
      asm.mneg     w4, w5, w6
    end
    assert_bytes [0xa4,0xfc,0x06,0x9b] do |asm|
      asm.mneg     x4, x5, x6
    end
    assert_bytes [0xd5,0xfe,0x17,0x1b] do |asm|
      asm.mneg     w21, w22, w23
    end
    assert_bytes [0x1f,0xff,0x19,0x1b] do |asm|
      asm.mneg     wzr, w24, w25
    end
    assert_bytes [0xfa,0xff,0x1b,0x1b] do |asm|
      asm.mneg     w26, wzr, w27
    end
    assert_bytes [0xbc,0xff,0x1f,0x1b] do |asm|
      asm.mneg     w28, w29, wzr
    end
    # MSUB <Xd>, <Xn>, <Xm>, XZR
  end

  def test_MOV_ORR_log_imm
    # MOV  <Wd|WSP>, #<imm>
    # ORR <Wd|WSP>, WZR, #<imm>
    # MOV  <Xd|SP>, #<imm>
    # ORR <Xd|SP>, XZR, #<imm>
    # MOV  <Xd|SP>, #<imm>
    # MOV  <Wd>, <Wm>
    # ORR <Wd>, WZR, <Wm>
    # MOV  <Xd>, <Xm>
    # ORR <Xd>, XZR, <Xm>
    # MOV  <Wd|WSP>, <Wn|WSP>
    # ADD <Wd|WSP>, <Wn|WSP>, #0
    # MOV  <Xd|SP>, <Xn|SP>
    # ADD <Xd|SP>, <Xn|SP>, #0
    # MOV  <Wd>, #<imm>
    # MOVZ <Wd>, #<imm16>, LSL #<shift>
    # MOV  <Xd>, #<imm>
    # MOVZ <Xd>, #<imm16>, LSL #<shift>
    assert_bytes [0x20,0x00,0x80,0x52] do |asm|
      asm.mov w0, 1
    end
    assert_bytes [0x20,0x00,0x80,0xd2] do |asm|
      asm.mov x0, 1
    end
    assert_bytes [0x20,0x00,0xa0,0x52] do |asm|
      asm.mov w0, 65536
    end
    assert_bytes [0x20,0x00,0xa0,0xd2] do |asm|
      asm.mov x0, 65536
    end
    assert_bytes [0x40,0x00,0x80,0x12] do |asm|
      asm.mov w0, -3
    end
    assert_bytes [0x40,0x00,0x80,0x92] do |asm|
      asm.mov x0, -3
    end
    assert_bytes [0x40,0x00,0xa0,0x12] do |asm|
      asm.mov w0, -131073
    end
    assert_bytes [0x40,0x00,0xa0,0x92] do |asm|
      asm.mov x0, -131073
    end
    assert_bytes [0xdf,0x03,0x00,0x91] do |asm|
      asm.mov      sp, x30
    end
    assert_bytes [0x9f,0x02,0x00,0x11] do |asm|
      asm.mov      wsp, w20
    end
    assert_bytes [0xeb,0x03,0x00,0x91] do |asm|
      asm.mov      x11, sp
    end
    assert_bytes [0xf8,0x03,0x00,0x11] do |asm|
      asm.mov      w24, wsp
    end
    assert_bytes [0xe3,0x8f,0x00,0x32] do |asm|
      asm.mov w3, 983055
    end
    assert_bytes [0xea,0xf3,0x01,0xb2] do |asm|
      asm.mov x10, -6148914691236517206
    end
    assert_bytes [0xe3,0x03,0x06,0xaa] do |asm|
      asm.mov      x3, x6
    end
    assert_bytes [0xe3,0x03,0x1f,0xaa] do |asm|
      asm.mov      x3, xzr
    end
    assert_bytes [0xff,0x03,0x02,0x2a] do |asm|
      asm.mov      wzr, w2
    end
    assert_bytes [0xe3,0x03,0x05,0x2a] do |asm|
      asm.mov      w3, w5
    end
    assert_bytes [0xe1,0xff,0x9f,0x52] do |asm|
      asm.mov     w1, 65535
    end
    assert_bytes [0x42,0x9a,0x80,0x12] do |asm|
      asm.mov     w2, -1235
    end
    assert_bytes [0x42,0x9a,0xc0,0xd2] do |asm|
      asm.mov      x2, 5299989643264
    end
    assert_bytes [0xe5,0x03,0x0b,0xaa] do |asm|
      asm.mov      x5, x11
    end
    assert_bytes [0xe1,0x03,0x06,0x2a] do |asm|
      asm.mov      w1, w6
    end
    assert_bytes [0xe1,0x03,0x06,0x2a] do |asm|
      asm.mov      w1, w6
    end
  end

  def test_MOVK
    # MOVK  <Wd>, #<imm>{, LSL #<shift>}
    # MOVK  <Xd>, #<imm>{, LSL #<shift>}
    asm.movk X0, 0x2a
    assert_one_insn "movk x0, #0x2a"
  end

  def test_movk_shift
    asm.movk X0, 0x2a, lsl: 16
    assert_one_insn "movk x0, #0x2a, lsl #16"
  end

  def test_MOVN
    # MOVN  <Wd>, #<imm>{, LSL #<shift>}
    # MOVN  <Xd>, #<imm>{, LSL #<shift>}
    # movn x3, 123
    assert_bytes [0x63, 0xf, 0x80, 0x92] do |asm|
      asm.movn x3, 123
    end
    # movn x3, 1, lsl #16
    assert_bytes [0x23, 00, 0xa0, 0x92] do |asm|
      asm.movn x3, 1, lsl: 16
    end
    # movn w3, 123
    assert_bytes [0x63, 0xf, 0x80, 0x12] do |asm|
      asm.movn w3, 123
    end
  end

  def test_MOVZ
    asm.movz X0, 0x2a
    assert_one_insn "movz x0, #0x2a"
  end

  def test_movz_shift
    asm.movz X0, 0x2a, lsl: 16
    assert_one_insn "movz x0, #0x2a, lsl #16"
  end

  def test_movz_with_w
    asm.movz W0, 0x2a
    assert_one_insn "movz w0, #0x2a"
  end

  def test_MRS
    # MRS  <Xt>, (<systemreg>|S<op0>_<op1>_<Cn>_<Cm>_<op2>)
    assert_bytes [0x00,0x42,0x38,0xd5] do |asm|
      asm.mrs x0, SPSel
    end
    assert_bytes [0x00,0x52,0x38,0xd5] do |asm|
      asm.mrs x0, ESR_EL1
    end
    assert_bytes [0x23,0x10,0x38,0xd5] do |asm|
      asm.mrs x3, ACTLR_EL1
    end
    assert_bytes [0x23,0x10,0x3c,0xd5] do |asm|
      asm.mrs x3, ACTLR_EL2
    end
    assert_bytes [0x23,0x10,0x3e,0xd5] do |asm|
      asm.mrs x3, ACTLR_EL3
    end
    assert_bytes [0x03,0x51,0x38,0xd5] do |asm|
      asm.mrs x3, AFSR0_EL1
    end
    assert_bytes [0x03,0x51,0x3c,0xd5] do |asm|
      asm.mrs x3, AFSR0_EL2
    end
    assert_bytes [0x03,0x51,0x3e,0xd5] do |asm|
      asm.mrs x3, AFSR0_EL3
    end
    assert_bytes [0xe3,0x00,0x39,0xd5] do |asm|
      asm.mrs x3, AIDR_EL1
    end
    assert_bytes [0x23,0x51,0x38,0xd5] do |asm|
      asm.mrs x3, AFSR1_EL1
    end
    assert_bytes [0x23,0x51,0x3c,0xd5] do |asm|
      asm.mrs x3, AFSR1_EL2
    end
    assert_bytes [0x23,0x51,0x3e,0xd5] do |asm|
      asm.mrs x3, AFSR1_EL3
    end
    assert_bytes [0x03,0xa3,0x38,0xd5] do |asm|
      asm.mrs x3, AMAIR_EL1
    end
    assert_bytes [0x03,0xa3,0x3c,0xd5] do |asm|
      asm.mrs x3, AMAIR_EL2
    end
    assert_bytes [0x03,0xa3,0x3e,0xd5] do |asm|
      asm.mrs x3, AMAIR_EL3
    end
    assert_bytes [0x03,0x00,0x39,0xd5] do |asm|
      asm.mrs x3, CCSIDR_EL1
    end
    assert_bytes [0x23,0x00,0x39,0xd5] do |asm|
      asm.mrs x3, CLIDR_EL1
    end
    assert_bytes [0x03,0xe0,0x3b,0xd5] do |asm|
      asm.mrs x3, CNTFRQ_EL0
    end
    assert_bytes [0x03,0xe1,0x3c,0xd5] do |asm|
      asm.mrs x3, CNTHCTL_EL2
    end
    assert_bytes [0x23,0xe2,0x3c,0xd5] do |asm|
      asm.mrs x3, CNTHP_CTL_EL2
    end
    assert_bytes [0x43,0xe2,0x3c,0xd5] do |asm|
      asm.mrs x3, CNTHP_CVAL_EL2
    end
    assert_bytes [0x03,0xe2,0x3c,0xd5] do |asm|
      asm.mrs x3, CNTHP_TVAL_EL2
    end
    assert_bytes [0x03,0xe1,0x38,0xd5] do |asm|
      asm.mrs x3, CNTKCTL_EL1
    end
    assert_bytes [0x23,0xe0,0x3b,0xd5] do |asm|
      asm.mrs x3, CNTPCT_EL0
    end
    assert_bytes [0x23,0xe2,0x3b,0xd5] do |asm|
      asm.mrs x3, CNTP_CTL_EL0
    end
    assert_bytes [0x43,0xe2,0x3b,0xd5] do |asm|
      asm.mrs x3, CNTP_CVAL_EL0
    end
    assert_bytes [0x03,0xe2,0x3b,0xd5] do |asm|
      asm.mrs x3, CNTP_TVAL_EL0
    end
    assert_bytes [0x43,0xe0,0x3b,0xd5] do |asm|
      asm.mrs x3, CNTVCT_EL0
    end
    assert_bytes [0x63,0xe0,0x3c,0xd5] do |asm|
      asm.mrs x3, CNTVOFF_EL2
    end
    assert_bytes [0x23,0xe3,0x3b,0xd5] do |asm|
      asm.mrs x3, CNTV_CTL_EL0
    end
    assert_bytes [0x43,0xe3,0x3b,0xd5] do |asm|
      asm.mrs x3, CNTV_CVAL_EL0
    end
    assert_bytes [0x03,0xe3,0x3b,0xd5] do |asm|
      asm.mrs x3, CNTV_TVAL_EL0
    end
    assert_bytes [0x23,0xd0,0x38,0xd5] do |asm|
      asm.mrs x3, CONTEXTIDR_EL1
    end
    assert_bytes [0x43,0x10,0x38,0xd5] do |asm|
      asm.mrs x3, CPACR_EL1
    end
    assert_bytes [0x43,0x11,0x3c,0xd5] do |asm|
      asm.mrs x3, CPTR_EL2
    end
    assert_bytes [0x43,0x11,0x3e,0xd5] do |asm|
      asm.mrs x3, CPTR_EL3
    end
    assert_bytes [0x03,0x00,0x3a,0xd5] do |asm|
      asm.mrs x3, CSSELR_EL1
    end
    assert_bytes [0x23,0x00,0x3b,0xd5] do |asm|
      asm.mrs x3, CTR_EL0
    end
    assert_bytes [0x43,0x42,0x38,0xd5] do |asm|
      asm.mrs x3, CurrentEL
    end
    assert_bytes [0x03,0x30,0x3c,0xd5] do |asm|
      asm.mrs x3, DACR32_EL2
    end
    assert_bytes [0xe3,0x00,0x3b,0xd5] do |asm|
      asm.mrs x3, DCZID_EL0
    end
    assert_bytes [0xc3,0x00,0x38,0xd5] do |asm|
      asm.mrs x3, REVIDR_EL1
    end
    assert_bytes [0x03,0x52,0x38,0xd5] do |asm|
      asm.mrs x3, ESR_EL1
    end
    assert_bytes [0x03,0x52,0x3c,0xd5] do |asm|
      asm.mrs x3, ESR_EL2
    end
    assert_bytes [0x03,0x52,0x3e,0xd5] do |asm|
      asm.mrs x3, ESR_EL3
    end
    assert_bytes [0x03,0x60,0x38,0xd5] do |asm|
      asm.mrs x3, FAR_EL1
    end
    assert_bytes [0x03,0x60,0x3c,0xd5] do |asm|
      asm.mrs x3, FAR_EL2
    end
    assert_bytes [0x03,0x60,0x3e,0xd5] do |asm|
      asm.mrs x3, FAR_EL3
    end
    assert_bytes [0x03,0x53,0x3c,0xd5] do |asm|
      asm.mrs x3, FPEXC32_EL2
    end
    assert_bytes [0xe3,0x11,0x3c,0xd5] do |asm|
      asm.mrs x3, HACR_EL2
    end
    assert_bytes [0x03,0x11,0x3c,0xd5] do |asm|
      asm.mrs x3, HCR_EL2
    end
    assert_bytes [0x83,0x60,0x3c,0xd5] do |asm|
      asm.mrs x3, HPFAR_EL2
    end
    assert_bytes [0x63,0x11,0x3c,0xd5] do |asm|
      asm.mrs x3, HSTR_EL2
    end
    assert_bytes [0x03,0x05,0x38,0xd5] do |asm|
      asm.mrs x3, ID_AA64DFR0_EL1
    end
    assert_bytes [0x23,0x05,0x38,0xd5] do |asm|
      asm.mrs x3, ID_AA64DFR1_EL1
    end
    assert_bytes [0x03,0x06,0x38,0xd5] do |asm|
      asm.mrs x3, ID_AA64ISAR0_EL1
    end
    assert_bytes [0x23,0x06,0x38,0xd5] do |asm|
      asm.mrs x3, ID_AA64ISAR1_EL1
    end
    assert_bytes [0x03,0x07,0x38,0xd5] do |asm|
      asm.mrs x3, ID_AA64MMFR0_EL1
    end
    assert_bytes [0x23,0x07,0x38,0xd5] do |asm|
      asm.mrs x3, ID_AA64MMFR1_EL1
    end
    assert_bytes [0x03,0x04,0x38,0xd5] do |asm|
      asm.mrs x3, ID_AA64PFR0_EL1
    end
    assert_bytes [0x23,0x04,0x38,0xd5] do |asm|
      asm.mrs x3, ID_AA64PFR1_EL1
    end
    assert_bytes [0x23,0x50,0x3c,0xd5] do |asm|
      asm.mrs x3, IFSR32_EL2
    end
    assert_bytes [0x03,0xc1,0x38,0xd5] do |asm|
      asm.mrs x3, ISR_EL1
    end
    assert_bytes [0x03,0xa2,0x38,0xd5] do |asm|
      asm.mrs x3, MAIR_EL1
    end
    assert_bytes [0x03,0xa2,0x3c,0xd5] do |asm|
      asm.mrs x3, MAIR_EL2
    end
    assert_bytes [0x03,0xa2,0x3e,0xd5] do |asm|
      asm.mrs x3, MAIR_EL3
    end
    assert_bytes [0x23,0x11,0x3c,0xd5] do |asm|
      asm.mrs x3, MDCR_EL2
    end
    assert_bytes [0x23,0x13,0x3e,0xd5] do |asm|
      asm.mrs x3, MDCR_EL3
    end
    assert_bytes [0x03,0x00,0x38,0xd5] do |asm|
      asm.mrs x3, MIDR_EL1
    end
    assert_bytes [0xa3,0x00,0x38,0xd5] do |asm|
      asm.mrs x3, MPIDR_EL1
    end
    assert_bytes [0x03,0x03,0x38,0xd5] do |asm|
      asm.mrs x3, MVFR0_EL1
    end
    assert_bytes [0x23,0x03,0x38,0xd5] do |asm|
      asm.mrs x3, MVFR1_EL1
    end
    assert_bytes [0x03,0x74,0x38,0xd5] do |asm|
      asm.mrs x3, PAR_EL1
    end
    assert_bytes [0x23,0xc0,0x38,0xd5] do |asm|
      asm.mrs x3, RVBAR_EL1
    end
    assert_bytes [0x23,0xc0,0x3c,0xd5] do |asm|
      asm.mrs x3, RVBAR_EL2
    end
    assert_bytes [0x23,0xc0,0x3e,0xd5] do |asm|
      asm.mrs x3, RVBAR_EL3
    end
    assert_bytes [0x03,0x11,0x3e,0xd5] do |asm|
      asm.mrs x3, SCR_EL3
    end
    assert_bytes [0x03,0x10,0x38,0xd5] do |asm|
      asm.mrs x3, SCTLR_EL1
    end
    assert_bytes [0x03,0x10,0x3c,0xd5] do |asm|
      asm.mrs x3, SCTLR_EL2
    end
    assert_bytes [0x03,0x10,0x3e,0xd5] do |asm|
      asm.mrs x3, SCTLR_EL3
    end
    assert_bytes [0x23,0x11,0x3e,0xd5] do |asm|
      asm.mrs x3, SDER32_EL3
    end
    assert_bytes [0x43,0x20,0x38,0xd5] do |asm|
      asm.mrs x3, TCR_EL1
    end
    assert_bytes [0x43,0x20,0x3c,0xd5] do |asm|
      asm.mrs x3, TCR_EL2
    end
    assert_bytes [0x43,0x20,0x3e,0xd5] do |asm|
      asm.mrs x3, TCR_EL3
    end
    #assert_bytes [0x03,0x00,0x32,0xd5] do |asm|
    #  asm.mrs x3, TEECR32_EL1
    #end
    #assert_bytes [0x03,0x10,0x32,0xd5] do |asm|
    #  asm.mrs x3, TEEHBR32_EL1
    #end
    assert_bytes [0x63,0xd0,0x3b,0xd5] do |asm|
      asm.mrs x3, TPIDRRO_EL0
    end
    assert_bytes [0x43,0xd0,0x3b,0xd5] do |asm|
      asm.mrs x3, TPIDR_EL0
    end
    assert_bytes [0x83,0xd0,0x38,0xd5] do |asm|
      asm.mrs x3, TPIDR_EL1
    end
    assert_bytes [0x43,0xd0,0x3c,0xd5] do |asm|
      asm.mrs x3, TPIDR_EL2
    end
    assert_bytes [0x43,0xd0,0x3e,0xd5] do |asm|
      asm.mrs x3, TPIDR_EL3
    end
    assert_bytes [0x03,0x20,0x38,0xd5] do |asm|
      asm.mrs x3, TTBR0_EL1
    end
    assert_bytes [0x03,0x20,0x3c,0xd5] do |asm|
      asm.mrs x3, TTBR0_EL2
    end
    assert_bytes [0x03,0x20,0x3e,0xd5] do |asm|
      asm.mrs x3, TTBR0_EL3
    end
    assert_bytes [0x23,0x20,0x38,0xd5] do |asm|
      asm.mrs x3, TTBR1_EL1
    end
    assert_bytes [0x03,0xc0,0x38,0xd5] do |asm|
      asm.mrs x3, VBAR_EL1
    end
    assert_bytes [0x03,0xc0,0x3c,0xd5] do |asm|
      asm.mrs x3, VBAR_EL2
    end
    assert_bytes [0x03,0xc0,0x3e,0xd5] do |asm|
      asm.mrs x3, VBAR_EL3
    end
    assert_bytes [0xa3,0x00,0x3c,0xd5] do |asm|
      asm.mrs x3, VMPIDR_EL2
    end
    assert_bytes [0x03,0x00,0x3c,0xd5] do |asm|
      asm.mrs x3, VPIDR_EL2
    end
    assert_bytes [0x43,0x21,0x3c,0xd5] do |asm|
      asm.mrs x3, VTCR_EL2
    end
    assert_bytes [0x03,0x21,0x3c,0xd5] do |asm|
      asm.mrs x3, VTTBR_EL2
    end
    assert_bytes [0x03,0x01,0x33,0xd5] do |asm|
      asm.mrs	x3, MDCCSR_EL0
    end
    assert_bytes [0x03,0x02,0x30,0xd5] do |asm|
      asm.mrs	x3, MDCCINT_EL1
    end
    assert_bytes [0x03,0x04,0x33,0xd5] do |asm|
      asm.mrs	x3, DBGDTR_EL0
    end
    assert_bytes [0x03,0x05,0x33,0xd5] do |asm|
      asm.mrs	x3, DBGDTRRX_EL0
    end
    assert_bytes [0x03,0x07,0x34,0xd5] do |asm|
      asm.mrs	x3, DBGVCR32_EL2
    end
    assert_bytes [0x43,0x00,0x30,0xd5] do |asm|
      asm.mrs	x3, OSDTRRX_EL1
    end
    assert_bytes [0x43,0x02,0x30,0xd5] do |asm|
      asm.mrs	x3, MDSCR_EL1
    end
    assert_bytes [0x43,0x03,0x30,0xd5] do |asm|
      asm.mrs	x3, OSDTRTX_EL1
    end
    assert_bytes [0x43,0x06,0x30,0xd5] do |asm|
      asm.mrs	x3, OSECCR_EL1
    end
    assert_bytes [0x83,0x00,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR0_EL1
    end
    assert_bytes [0x83,0x01,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR1_EL1
    end
    assert_bytes [0x83,0x02,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR2_EL1
    end
    assert_bytes [0x83,0x03,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR3_EL1
    end
    assert_bytes [0x83,0x04,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR4_EL1
    end
    assert_bytes [0x83,0x05,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR5_EL1
    end
    assert_bytes [0x83,0x06,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR6_EL1
    end
    assert_bytes [0x83,0x07,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR7_EL1
    end
    assert_bytes [0x83,0x08,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR8_EL1
    end
    assert_bytes [0x83,0x09,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR9_EL1
    end
    assert_bytes [0x83,0x0a,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR10_EL1
    end
    assert_bytes [0x83,0x0b,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR11_EL1
    end
    assert_bytes [0x83,0x0c,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR12_EL1
    end
    assert_bytes [0x83,0x0d,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR13_EL1
    end
    assert_bytes [0x83,0x0e,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR14_EL1
    end
    assert_bytes [0x83,0x0f,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBVR15_EL1
    end
    assert_bytes [0xa3,0x00,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR0_EL1
    end
    assert_bytes [0xa3,0x01,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR1_EL1
    end
    assert_bytes [0xa3,0x02,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR2_EL1
    end
    assert_bytes [0xa3,0x03,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR3_EL1
    end
    assert_bytes [0xa3,0x04,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR4_EL1
    end
    assert_bytes [0xa3,0x05,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR5_EL1
    end
    assert_bytes [0xa3,0x06,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR6_EL1
    end
    assert_bytes [0xa3,0x07,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR7_EL1
    end
    assert_bytes [0xa3,0x08,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR8_EL1
    end
    assert_bytes [0xa3,0x09,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR9_EL1
    end
    assert_bytes [0xa3,0x0a,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR10_EL1
    end
    assert_bytes [0xa3,0x0b,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR11_EL1
    end
    assert_bytes [0xa3,0x0c,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR12_EL1
    end
    assert_bytes [0xa3,0x0d,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR13_EL1
    end
    assert_bytes [0xa3,0x0e,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR14_EL1
    end
    assert_bytes [0xa3,0x0f,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGBCR15_EL1
    end
    assert_bytes [0xc3,0x00,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR0_EL1
    end
    assert_bytes [0xc3,0x01,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR1_EL1
    end
    assert_bytes [0xc3,0x02,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR2_EL1
    end
    assert_bytes [0xc3,0x03,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR3_EL1
    end
    assert_bytes [0xc3,0x04,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR4_EL1
    end
    assert_bytes [0xc3,0x05,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR5_EL1
    end
    assert_bytes [0xc3,0x06,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR6_EL1
    end
    assert_bytes [0xc3,0x07,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR7_EL1
    end
    assert_bytes [0xc3,0x08,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR8_EL1
    end
    assert_bytes [0xc3,0x09,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR9_EL1
    end
    assert_bytes [0xc3,0x0a,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR10_EL1
    end
    assert_bytes [0xc3,0x0b,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR11_EL1
    end
    assert_bytes [0xc3,0x0c,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR12_EL1
    end
    assert_bytes [0xc3,0x0d,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR13_EL1
    end
    assert_bytes [0xc3,0x0e,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR14_EL1
    end
    assert_bytes [0xc3,0x0f,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWVR15_EL1
    end
    assert_bytes [0xe3,0x00,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR0_EL1
    end
    assert_bytes [0xe3,0x01,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR1_EL1
    end
    assert_bytes [0xe3,0x02,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR2_EL1
    end
    assert_bytes [0xe3,0x03,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR3_EL1
    end
    assert_bytes [0xe3,0x04,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR4_EL1
    end
    assert_bytes [0xe3,0x05,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR5_EL1
    end
    assert_bytes [0xe3,0x06,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR6_EL1
    end
    assert_bytes [0xe3,0x07,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR7_EL1
    end
    assert_bytes [0xe3,0x08,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR8_EL1
    end
    assert_bytes [0xe3,0x09,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR9_EL1
    end
    assert_bytes [0xe3,0x0a,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR10_EL1
    end
    assert_bytes [0xe3,0x0b,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR11_EL1
    end
    assert_bytes [0xe3,0x0c,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR12_EL1
    end
    assert_bytes [0xe3,0x0d,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR13_EL1
    end
    assert_bytes [0xe3,0x0e,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR14_EL1
    end
    assert_bytes [0xe3,0x0f,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGWCR15_EL1
    end
    assert_bytes [0x03,0x10,0x30,0xd5] do |asm|
      asm.mrs	x3, MDRAR_EL1
    end
    assert_bytes [0x83,0x11,0x30,0xd5] do |asm|
      asm.mrs	x3, OSLSR_EL1
    end
    assert_bytes [0x83,0x13,0x30,0xd5] do |asm|
      asm.mrs	x3, OSDLR_EL1
    end
    assert_bytes [0x83,0x14,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGPRCR_EL1
    end
    assert_bytes [0xc3,0x78,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGCLAIMSET_EL1
    end
    assert_bytes [0xc3,0x79,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGCLAIMCLR_EL1
    end
    assert_bytes [0xc3,0x7e,0x30,0xd5] do |asm|
      asm.mrs	x3, DBGAUTHSTATUS_EL1
    end
    #assert_bytes [0x81,0xf6,0x3a,0xd5] do |asm|
    #  asm.mrs    x1, S3_2_C15_C6_4
    #end
    #assert_bytes [0x83,0xb1,0x3b,0xd5] do |asm|
    #  asm.mrs	x3, S3_3_C11_C1_4
    #end
    #assert_bytes [0x83,0xb1,0x3b,0xd5] do |asm|
    #  asm.mrs	x3, S3_3_C11_C1_4
    #end
    assert_bytes [0x00,0x01,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_PFR0_EL1
    end
    assert_bytes [0x20,0x01,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_PFR1_EL1
    end
    assert_bytes [0x40,0x01,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_DFR0_EL1
    end
    assert_bytes [0x60,0x01,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_AFR0_EL1
    end
    assert_bytes [0x00,0x02,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_ISAR0_EL1
    end
    assert_bytes [0x20,0x02,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_ISAR1_EL1
    end
    assert_bytes [0x40,0x02,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_ISAR2_EL1
    end
    assert_bytes [0x60,0x02,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_ISAR3_EL1
    end
    assert_bytes [0x80,0x02,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_ISAR4_EL1
    end
    assert_bytes [0xa0,0x02,0x38,0xd5] do |asm|
      asm.mrs	x0, ID_ISAR5_EL1
    end
    assert_bytes [0x20,0x51,0x38,0xd5] do |asm|
      asm.mrs	x0, AFSR1_EL1
    end
    assert_bytes [0x00,0x51,0x38,0xd5] do |asm|
      asm.mrs	x0, AFSR0_EL1
    end
    assert_bytes [0xc0,0x00,0x38,0xd5] do |asm|
      asm.mrs	x0, REVIDR_EL1
    end
    assert_bytes [0xe0,0xa4,0x38,0xd5] do |asm|
      asm.mrs    x0, LORID_EL1
    end
    assert_bytes [0x6d,0x42,0x38,0xd5] do |asm|
      asm.mrs x13, PAN
    end
    assert_bytes [0x43,0x07,0x38,0xd5] do |asm|
      asm.mrs x3, ID_AA64MMFR2_EL1
    end
    assert_bytes [0x00,0x9a,0x38,0xd5] do |asm|
      asm.mrs x0, PMBLIMITR_EL1
    end
    assert_bytes [0x20,0x9a,0x38,0xd5] do |asm|
      asm.mrs x0, PMBPTR_EL1
    end
    assert_bytes [0x60,0x9a,0x38,0xd5] do |asm|
      asm.mrs x0, PMBSR_EL1
    end
    assert_bytes [0xe0,0x9a,0x38,0xd5] do |asm|
      asm.mrs x0, PMBIDR_EL1
    end
    assert_bytes [0x00,0x99,0x3c,0xd5] do |asm|
      asm.mrs x0, PMSCR_EL2
    end
    #assert_bytes [0x00,0x99,0x3d,0xd5] do |asm|
    #  asm.mrs x0, PMSCR_EL12
    #end
    assert_bytes [0x00,0x99,0x38,0xd5] do |asm|
      asm.mrs x0, PMSCR_EL1
    end
    assert_bytes [0x40,0x99,0x38,0xd5] do |asm|
      asm.mrs x0, PMSICR_EL1
    end
    assert_bytes [0x60,0x99,0x38,0xd5] do |asm|
      asm.mrs x0, PMSIRR_EL1
    end
    assert_bytes [0x80,0x99,0x38,0xd5] do |asm|
      asm.mrs x0, PMSFCR_EL1
    end
    assert_bytes [0xa0,0x99,0x38,0xd5] do |asm|
      asm.mrs x0, PMSEVFR_EL1
    end
    assert_bytes [0xc0,0x99,0x38,0xd5] do |asm|
      asm.mrs x0, PMSLATFR_EL1
    end
    assert_bytes [0xe0,0x99,0x38,0xd5] do |asm|
      asm.mrs x0, PMSIDR_EL1
    end
    assert_bytes [0x82,0x42,0x38,0xd5] do |asm|
      asm.mrs     x2, UAO
    end
    assert_bytes [0x20,0x53,0x38,0xd5] do |asm|
      asm.mrs     x0, ERRSELR_EL1
    end
    assert_bytes [0x2f,0x53,0x38,0xd5] do |asm|
      asm.mrs     x15, ERRSELR_EL1
    end
    assert_bytes [0x39,0x53,0x38,0xd5] do |asm|
      asm.mrs     x25, ERRSELR_EL1
    end
    assert_bytes [0x21,0x54,0x38,0xd5] do |asm|
      asm.mrs     x1, ERXCTLR_EL1
    end
    assert_bytes [0x42,0x54,0x38,0xd5] do |asm|
      asm.mrs     x2, ERXSTATUS_EL1
    end
    assert_bytes [0x63,0x54,0x38,0xd5] do |asm|
      asm.mrs     x3, ERXADDR_EL1
    end
    assert_bytes [0x04,0x55,0x38,0xd5] do |asm|
      asm.mrs     x4, ERXMISC0_EL1
    end
    assert_bytes [0x25,0x55,0x38,0xd5] do |asm|
      asm.mrs     x5, ERXMISC1_EL1
    end
    assert_bytes [0x26,0xc1,0x38,0xd5] do |asm|
      asm.mrs     x6, DISR_EL1
    end
    assert_bytes [0x27,0xc1,0x3c,0xd5] do |asm|
      asm.mrs     x7, VDISR_EL2
    end
    assert_bytes [0x68,0x52,0x3c,0xd5] do |asm|
      asm.mrs     x8, VSESR_EL2
    end
    assert_bytes [0x00,0x53,0x38,0xd5] do |asm|
      asm.mrs     x0, ERRIDR_EL1
    end
    assert_bytes [0x01,0x54,0x38,0xd5] do |asm|
      asm.mrs     x1, ERXFR_EL1
    end
  end

  def test_MSR_imm
    skip "Fixme!"
    # MSR  <pstatefield>, #<imm>
    assert_bytes [0xbf,0x40,0x00,0xd5] do |asm|
      asm.msr SPSel, 0
    end
    assert_bytes [0xdf,0x40,0x03,0xd5] do |asm|
      asm.msr DAIFSet, 0
    end
    assert_bytes [0x9f,0x40,0x00,0xd5] do |asm|
      asm.msr PAN, 0
    end
    assert_bytes [0x9f,0x41,0x00,0xd5] do |asm|
      asm.msr PAN, 1
    end
    assert_bytes [0x7f,0x40,0x00,0xd5] do |asm|
      asm.msr     UAO, 0
    end
    assert_bytes [0x7f,0x41,0x00,0xd5] do |asm|
      asm.msr     UAO, 1
    end
  end

  def test_MSR_reg
    # MSR  (<systemreg>|S<op0>_<op1>_<Cn>_<Cm>_<op2>), <Xt>
    assert_bytes [0x00,0x42,0x18,0xd5] do |asm|
      asm.msr SPSel, x0
    end
    assert_bytes [0x00,0x52,0x18,0xd5] do |asm|
      asm.msr ESR_EL1, x0
    end
    assert_bytes [0x23,0x10,0x18,0xd5] do |asm|
      asm.msr ACTLR_EL1, x3
    end
    assert_bytes [0x23,0x10,0x1c,0xd5] do |asm|
      asm.msr ACTLR_EL2, x3
    end
    assert_bytes [0x23,0x10,0x1e,0xd5] do |asm|
      asm.msr ACTLR_EL3, x3
    end
    assert_bytes [0x03,0x51,0x18,0xd5] do |asm|
      asm.msr AFSR0_EL1, x3
    end
    assert_bytes [0x03,0x51,0x1c,0xd5] do |asm|
      asm.msr AFSR0_EL2, x3
    end
    assert_bytes [0x03,0x51,0x1e,0xd5] do |asm|
      asm.msr AFSR0_EL3, x3
    end
    assert_bytes [0x23,0x51,0x18,0xd5] do |asm|
      asm.msr AFSR1_EL1, x3
    end
    assert_bytes [0x23,0x51,0x1c,0xd5] do |asm|
      asm.msr AFSR1_EL2, x3
    end
    assert_bytes [0x23,0x51,0x1e,0xd5] do |asm|
      asm.msr AFSR1_EL3, x3
    end
    assert_bytes [0x03,0xa3,0x18,0xd5] do |asm|
      asm.msr AMAIR_EL1, x3
    end
    assert_bytes [0x03,0xa3,0x1c,0xd5] do |asm|
      asm.msr AMAIR_EL2, x3
    end
    assert_bytes [0x03,0xa3,0x1e,0xd5] do |asm|
      asm.msr AMAIR_EL3, x3
    end
    assert_bytes [0x03,0xe0,0x1b,0xd5] do |asm|
      asm.msr CNTFRQ_EL0, x3
    end
    assert_bytes [0x03,0xe1,0x1c,0xd5] do |asm|
      asm.msr CNTHCTL_EL2, x3
    end
    assert_bytes [0x23,0xe2,0x1c,0xd5] do |asm|
      asm.msr CNTHP_CTL_EL2, x3
    end
    assert_bytes [0x43,0xe2,0x1c,0xd5] do |asm|
      asm.msr CNTHP_CVAL_EL2, x3
    end
    assert_bytes [0x03,0xe2,0x1c,0xd5] do |asm|
      asm.msr CNTHP_TVAL_EL2, x3
    end
    assert_bytes [0x03,0xe1,0x18,0xd5] do |asm|
      asm.msr CNTKCTL_EL1, x3
    end
    assert_bytes [0x23,0xe2,0x1b,0xd5] do |asm|
      asm.msr CNTP_CTL_EL0, x3
    end
    assert_bytes [0x43,0xe2,0x1b,0xd5] do |asm|
      asm.msr CNTP_CVAL_EL0, x3
    end
    assert_bytes [0x03,0xe2,0x1b,0xd5] do |asm|
      asm.msr CNTP_TVAL_EL0, x3
    end
    assert_bytes [0x63,0xe0,0x1c,0xd5] do |asm|
      asm.msr CNTVOFF_EL2, x3
    end
    assert_bytes [0x23,0xe3,0x1b,0xd5] do |asm|
      asm.msr CNTV_CTL_EL0, x3
    end
    assert_bytes [0x43,0xe3,0x1b,0xd5] do |asm|
      asm.msr CNTV_CVAL_EL0, x3
    end
    assert_bytes [0x03,0xe3,0x1b,0xd5] do |asm|
      asm.msr CNTV_TVAL_EL0, x3
    end
    assert_bytes [0x23,0xd0,0x18,0xd5] do |asm|
      asm.msr CONTEXTIDR_EL1, x3
    end
    assert_bytes [0x43,0x10,0x18,0xd5] do |asm|
      asm.msr CPACR_EL1, x3
    end
    assert_bytes [0x43,0x11,0x1c,0xd5] do |asm|
      asm.msr CPTR_EL2, x3
    end
    assert_bytes [0x43,0x11,0x1e,0xd5] do |asm|
      asm.msr CPTR_EL3, x3
    end
    assert_bytes [0x03,0x00,0x1a,0xd5] do |asm|
      asm.msr CSSELR_EL1, x3
    end
    assert_bytes [0x43,0x42,0x18,0xd5] do |asm|
      asm.msr CurrentEL, x3
    end
    assert_bytes [0x03,0x30,0x1c,0xd5] do |asm|
      asm.msr DACR32_EL2, x3
    end
    assert_bytes [0x03,0x52,0x18,0xd5] do |asm|
      asm.msr ESR_EL1, x3
    end
    assert_bytes [0x03,0x52,0x1c,0xd5] do |asm|
      asm.msr ESR_EL2, x3
    end
    assert_bytes [0x03,0x52,0x1e,0xd5] do |asm|
      asm.msr ESR_EL3, x3
    end
    assert_bytes [0x03,0x60,0x18,0xd5] do |asm|
      asm.msr FAR_EL1, x3
    end
    assert_bytes [0x03,0x60,0x1c,0xd5] do |asm|
      asm.msr FAR_EL2, x3
    end
    assert_bytes [0x03,0x60,0x1e,0xd5] do |asm|
      asm.msr FAR_EL3, x3
    end
    assert_bytes [0x03,0x53,0x1c,0xd5] do |asm|
      asm.msr FPEXC32_EL2, x3
    end
    assert_bytes [0xe3,0x11,0x1c,0xd5] do |asm|
      asm.msr HACR_EL2, x3
    end
    assert_bytes [0x03,0x11,0x1c,0xd5] do |asm|
      asm.msr HCR_EL2, x3
    end
    assert_bytes [0x83,0x60,0x1c,0xd5] do |asm|
      asm.msr HPFAR_EL2, x3
    end
    assert_bytes [0x63,0x11,0x1c,0xd5] do |asm|
      asm.msr HSTR_EL2, x3
    end
    assert_bytes [0x23,0x50,0x1c,0xd5] do |asm|
      asm.msr IFSR32_EL2, x3
    end
    assert_bytes [0x03,0xa2,0x18,0xd5] do |asm|
      asm.msr MAIR_EL1, x3
    end
    assert_bytes [0x03,0xa2,0x1c,0xd5] do |asm|
      asm.msr MAIR_EL2, x3
    end
    assert_bytes [0x03,0xa2,0x1e,0xd5] do |asm|
      asm.msr MAIR_EL3, x3
    end
    assert_bytes [0x23,0x11,0x1c,0xd5] do |asm|
      asm.msr MDCR_EL2, x3
    end
    assert_bytes [0x23,0x13,0x1e,0xd5] do |asm|
      asm.msr MDCR_EL3, x3
    end
    assert_bytes [0x03,0x74,0x18,0xd5] do |asm|
      asm.msr PAR_EL1, x3
    end
    assert_bytes [0x03,0x11,0x1e,0xd5] do |asm|
      asm.msr SCR_EL3, x3
    end
    assert_bytes [0x03,0x10,0x18,0xd5] do |asm|
      asm.msr SCTLR_EL1, x3
    end
    assert_bytes [0x03,0x10,0x1c,0xd5] do |asm|
      asm.msr SCTLR_EL2, x3
    end
    assert_bytes [0x03,0x10,0x1e,0xd5] do |asm|
      asm.msr SCTLR_EL3, x3
    end
    assert_bytes [0x23,0x11,0x1e,0xd5] do |asm|
      asm.msr SDER32_EL3, x3
    end
    assert_bytes [0x43,0x20,0x18,0xd5] do |asm|
      asm.msr TCR_EL1, x3
    end
    assert_bytes [0x43,0x20,0x1c,0xd5] do |asm|
      asm.msr TCR_EL2, x3
    end
    assert_bytes [0x43,0x20,0x1e,0xd5] do |asm|
      asm.msr TCR_EL3, x3
    end
    #assert_bytes [0x03,0x00,0x12,0xd5] do |asm|
    #  asm.msr TEECR32_EL1, x3
    #end
    #assert_bytes [0x03,0x10,0x12,0xd5] do |asm|
    #  asm.msr TEEHBR32_EL1, x3
    #end
    assert_bytes [0x63,0xd0,0x1b,0xd5] do |asm|
      asm.msr TPIDRRO_EL0, x3
    end
    assert_bytes [0x43,0xd0,0x1b,0xd5] do |asm|
      asm.msr TPIDR_EL0, x3
    end
    assert_bytes [0x83,0xd0,0x18,0xd5] do |asm|
      asm.msr TPIDR_EL1, x3
    end
    assert_bytes [0x43,0xd0,0x1c,0xd5] do |asm|
      asm.msr TPIDR_EL2, x3
    end
    assert_bytes [0x43,0xd0,0x1e,0xd5] do |asm|
      asm.msr TPIDR_EL3, x3
    end
    assert_bytes [0x03,0x20,0x18,0xd5] do |asm|
      asm.msr TTBR0_EL1, x3
    end
    assert_bytes [0x03,0x20,0x1c,0xd5] do |asm|
      asm.msr TTBR0_EL2, x3
    end
    assert_bytes [0x03,0x20,0x1e,0xd5] do |asm|
      asm.msr TTBR0_EL3, x3
    end
    assert_bytes [0x23,0x20,0x18,0xd5] do |asm|
      asm.msr TTBR1_EL1, x3
    end
    assert_bytes [0x03,0xc0,0x18,0xd5] do |asm|
      asm.msr VBAR_EL1, x3
    end
    assert_bytes [0x03,0xc0,0x1c,0xd5] do |asm|
      asm.msr VBAR_EL2, x3
    end
    assert_bytes [0x03,0xc0,0x1e,0xd5] do |asm|
      asm.msr VBAR_EL3, x3
    end
    assert_bytes [0xa3,0x00,0x1c,0xd5] do |asm|
      asm.msr VMPIDR_EL2, x3
    end
    assert_bytes [0x03,0x00,0x1c,0xd5] do |asm|
      asm.msr VPIDR_EL2, x3
    end
    assert_bytes [0x43,0x21,0x1c,0xd5] do |asm|
      asm.msr VTCR_EL2, x3
    end
    assert_bytes [0x03,0x21,0x1c,0xd5] do |asm|
      asm.msr VTTBR_EL2, x3
    end
    assert_bytes [0x03,0x42,0x18,0xd5] do |asm|
      asm.msr  SPSel, x3
    end
    #assert_bytes [0x81,0xb6,0x1a,0xd5] do |asm|
    #  asm.msr  S3_2_C11_C6_4, x1
    #end
    #assert_bytes [0x00,0x00,0x00,0xd5] do |asm|
    #  asm.msr  S0_0_C0_C0_0, x0
    #end
    #assert_bytes [0xa2,0x34,0x0a,0xd5] do |asm|
    #  asm.msr  S1_2_C3_C4_5, x2
    #end
    assert_bytes [0x40,0xc0,0x1e,0xd5] do |asm|
      asm.msr	RMR_EL3, x0
    end
    assert_bytes [0x40,0xc0,0x1c,0xd5] do |asm|
      asm.msr	RMR_EL2, x0
    end
    assert_bytes [0x40,0xc0,0x18,0xd5] do |asm|
      asm.msr	RMR_EL1, x0
    end
    assert_bytes [0x83,0x10,0x10,0xd5] do |asm|
      asm.msr	OSLAR_EL1, x3
    end
    assert_bytes [0x03,0x05,0x13,0xd5] do |asm|
      asm.msr	DBGDTRTX_EL0, x3
    end
    assert_bytes [0x00,0xa4,0x18,0xd5] do |asm|
      asm.msr    LORSA_EL1, x0
    end
    assert_bytes [0x20,0xa4,0x18,0xd5] do |asm|
      asm.msr    LOREA_EL1, x0
    end
    assert_bytes [0x40,0xa4,0x18,0xd5] do |asm|
      asm.msr    LORN_EL1, x0
    end
    assert_bytes [0x60,0xa4,0x18,0xd5] do |asm|
      asm.msr    LORC_EL1, x0
    end
    assert_bytes [0x65,0x42,0x18,0xd5] do |asm|
      asm.msr PAN, x5
    end
    assert_bytes [0x20,0x20,0x1c,0xd5] do |asm|
      asm.msr TTBR1_EL2, x0
    end
    assert_bytes [0x20,0xd0,0x1c,0xd5] do |asm|
      asm.msr CONTEXTIDR_EL2, x0
    end
    assert_bytes [0x00,0xe3,0x1c,0xd5] do |asm|
      asm.msr CNTHV_TVAL_EL2, x0
    end
    assert_bytes [0x40,0xe3,0x1c,0xd5] do |asm|
      asm.msr CNTHV_CVAL_EL2, x0
    end
    assert_bytes [0x20,0xe3,0x1c,0xd5] do |asm|
      asm.msr CNTHV_CTL_EL2, x0
    end
    #assert_bytes [0x00,0x10,0x1d,0xd5] do |asm|
    #  asm.msr SCTLR_EL12, x0
    #end
    #assert_bytes [0x40,0x10,0x1d,0xd5] do |asm|
    #  asm.msr CPACR_EL12, x0
    #end
    #assert_bytes [0x00,0x20,0x1d,0xd5] do |asm|
    #  asm.msr TTBR0_EL12, x0
    #end
    #assert_bytes [0x20,0x20,0x1d,0xd5] do |asm|
    #  asm.msr TTBR1_EL12, x0
    #end
    #assert_bytes [0x40,0x20,0x1d,0xd5] do |asm|
    #  asm.msr TCR_EL12, x0
    #end
    #assert_bytes [0x00,0x51,0x1d,0xd5] do |asm|
    #  asm.msr AFSR0_EL12, x0
    #end
    #assert_bytes [0x20,0x51,0x1d,0xd5] do |asm|
    #  asm.msr AFSR1_EL12, x0
    #end
    #assert_bytes [0x00,0x52,0x1d,0xd5] do |asm|
    #  asm.msr ESR_EL12, x0
    #end
    #assert_bytes [0x00,0x60,0x1d,0xd5] do |asm|
    #  asm.msr FAR_EL12, x0
    #end
    #assert_bytes [0x00,0xa2,0x1d,0xd5] do |asm|
    #  asm.msr MAIR_EL12, x0
    #end
    #assert_bytes [0x00,0xa3,0x1d,0xd5] do |asm|
    #  asm.msr AMAIR_EL12, x0
    #end
    #assert_bytes [0x00,0xc0,0x1d,0xd5] do |asm|
    #  asm.msr VBAR_EL12, x0
    #end
    #assert_bytes [0x20,0xd0,0x1d,0xd5] do |asm|
    #  asm.msr CONTEXTIDR_EL12, x0
    #end
    #assert_bytes [0x00,0xe1,0x1d,0xd5] do |asm|
    #  asm.msr CNTKCTL_EL12, x0
    #end
    #assert_bytes [0x00,0xe2,0x1d,0xd5] do |asm|
    #  asm.msr CNTP_TVAL_EL02, x0
    #end
    #assert_bytes [0x20,0xe2,0x1d,0xd5] do |asm|
    #  asm.msr CNTP_CTL_EL02, x0
    #end
    #assert_bytes [0x40,0xe2,0x1d,0xd5] do |asm|
    #  asm.msr CNTP_CVAL_EL02, x0
    #end
    #assert_bytes [0x00,0xe3,0x1d,0xd5] do |asm|
    #  asm.msr CNTV_TVAL_EL02, x0
    #end
    #assert_bytes [0x20,0xe3,0x1d,0xd5] do |asm|
    #  asm.msr CNTV_CTL_EL02, x0
    #end
    #assert_bytes [0x40,0xe3,0x1d,0xd5] do |asm|
    #  asm.msr CNTV_CVAL_EL02, x0
    #end
    #assert_bytes [0x00,0x40,0x1d,0xd5] do |asm|
    #  asm.msr SPSR_EL12, x0
    #end
    #assert_bytes [0x20,0x40,0x1d,0xd5] do |asm|
    #  asm.msr ELR_EL12, x0
    #end
    assert_bytes [0x00,0x9a,0x18,0xd5] do |asm|
      asm.msr PMBLIMITR_EL1, x0
    end
    assert_bytes [0x20,0x9a,0x18,0xd5] do |asm|
      asm.msr PMBPTR_EL1, x0
    end
    assert_bytes [0x60,0x9a,0x18,0xd5] do |asm|
      asm.msr PMBSR_EL1, x0
    end
    assert_bytes [0xe0,0x9a,0x18,0xd5] do |asm|
      asm.msr PMBIDR_EL1, x0
    end
    assert_bytes [0x00,0x99,0x1c,0xd5] do |asm|
      asm.msr PMSCR_EL2, x0
    end
    #assert_bytes [0x00,0x99,0x1d,0xd5] do |asm|
    #  asm.msr PMSCR_EL12, x0
    #end
    assert_bytes [0x00,0x99,0x18,0xd5] do |asm|
      asm.msr PMSCR_EL1, x0
    end
    assert_bytes [0x40,0x99,0x18,0xd5] do |asm|
      asm.msr PMSICR_EL1, x0
    end
    assert_bytes [0x60,0x99,0x18,0xd5] do |asm|
      asm.msr PMSIRR_EL1, x0
    end
    assert_bytes [0x80,0x99,0x18,0xd5] do |asm|
      asm.msr PMSFCR_EL1, x0
    end
    assert_bytes [0xa0,0x99,0x18,0xd5] do |asm|
      asm.msr PMSEVFR_EL1, x0
    end
    assert_bytes [0xc0,0x99,0x18,0xd5] do |asm|
      asm.msr PMSLATFR_EL1, x0
    end
    assert_bytes [0xe0,0x99,0x18,0xd5] do |asm|
      asm.msr PMSIDR_EL1, x0
    end
    assert_bytes [0x81,0x42,0x18,0xd5] do |asm|
      asm.msr     UAO, x1
    end
    assert_bytes [0x20,0x53,0x18,0xd5] do |asm|
      asm.msr     ERRSELR_EL1, x0
    end
    assert_bytes [0x2f,0x53,0x18,0xd5] do |asm|
      asm.msr     ERRSELR_EL1, x15
    end
    assert_bytes [0x39,0x53,0x18,0xd5] do |asm|
      asm.msr     ERRSELR_EL1, x25
    end
    assert_bytes [0x21,0x54,0x18,0xd5] do |asm|
      asm.msr     ERXCTLR_EL1, x1
    end
    assert_bytes [0x42,0x54,0x18,0xd5] do |asm|
      asm.msr     ERXSTATUS_EL1, x2
    end
    assert_bytes [0x63,0x54,0x18,0xd5] do |asm|
      asm.msr     ERXADDR_EL1, x3
    end
    assert_bytes [0x04,0x55,0x18,0xd5] do |asm|
      asm.msr     ERXMISC0_EL1, x4
    end
    assert_bytes [0x25,0x55,0x18,0xd5] do |asm|
      asm.msr     ERXMISC1_EL1, x5
    end
    assert_bytes [0x26,0xc1,0x18,0xd5] do |asm|
      asm.msr     DISR_EL1, x6
    end
    assert_bytes [0x27,0xc1,0x1c,0xd5] do |asm|
      asm.msr     VDISR_EL2, x7
    end
    assert_bytes [0x68,0x52,0x1c,0xd5] do |asm|
      asm.msr     VSESR_EL2, x8
    end
  end

  def test_MSUB
    # MSUB  <Wd>, <Wn>, <Wm>, <Wa>
    # MSUB  <Xd>, <Xn>, <Xm>, <Xa>
    assert_bytes [0x41,0x90,0x03,0x1b] do |asm|
      asm.msub   w1, w2, w3, w4
    end
    assert_bytes [0x41,0x90,0x03,0x9b] do |asm|
      asm.msub   x1, x2, x3, x4
    end
    assert_bytes [0x61,0x90,0x07,0x1b] do |asm|
      asm.msub     w1, w3, w7, w4
    end
    assert_bytes [0x1f,0xac,0x09,0x1b] do |asm|
      asm.msub     wzr, w0, w9, w11
    end
    assert_bytes [0xed,0x93,0x04,0x1b] do |asm|
      asm.msub     w13, wzr, w4, w4
    end
    assert_bytes [0xd3,0xf7,0x1f,0x1b] do |asm|
      asm.msub     w19, w30, wzr, w29
    end
    assert_bytes [0x61,0x90,0x07,0x9b] do |asm|
      asm.msub     x1, x3, x7, x4
    end
    assert_bytes [0x1f,0xac,0x09,0x9b] do |asm|
      asm.msub     xzr, x0, x9, x11
    end
    assert_bytes [0xed,0x93,0x04,0x9b] do |asm|
      asm.msub     x13, xzr, x4, x4
    end
    assert_bytes [0xd3,0xf7,0x1f,0x9b] do |asm|
      asm.msub     x19, x30, xzr, x29
    end
  end

  def test_MUL_MADD
    skip "Fixme!"
    # MUL  <Wd>, <Wn>, <Wm>
    # MADD <Wd>, <Wn>, <Wm>, WZR
    # MUL  <Xd>, <Xn>, <Xm>
    # MADD <Xd>, <Xn>, <Xm>, XZR
  end

  def test_MVN_ORN_log_shift
    skip "Fixme!"
    # MVN  <Wd>, <Wm>{, <shift> #<amount>}
    # ORN <Wd>, WZR, <Wm>{, <shift> #<amount>}
    # MVN  <Xd>, <Xm>{, <shift> #<amount>}
    # ORN <Xd>, XZR, <Xm>{, <shift> #<amount>}
  end

  def test_NEG_SUB_addsub_shift
    skip "Fixme!"
    # NEG  <Wd>, <Wm>{, <shift> #<amount>}
    # SUB  <Wd>, WZR, <Wm> {, <shift> #<amount>}
    # NEG  <Xd>, <Xm>{, <shift> #<amount>}
    # SUB  <Xd>, XZR, <Xm> {, <shift> #<amount>}
  end

  def test_NEGS_SUBS_addsub_shift
    skip "Fixme!"
    # NEGS  <Wd>, <Wm>{, <shift> #<amount>}
    # SUBS <Wd>, WZR, <Wm> {, <shift> #<amount>}
    # NEGS  <Xd>, <Xm>{, <shift> #<amount>}
    # SUBS <Xd>, XZR, <Xm> {, <shift> #<amount>}
  end

  def test_NGC_SBC
    skip "Fixme!"
    # NGC  <Wd>, <Wm>
    # SBC <Wd>, WZR, <Wm>
    # NGC  <Xd>, <Xm>
    # SBC <Xd>, XZR, <Xm>
  end

  def test_NGCS_SBCS
    skip "Fixme!"
    # NGCS  <Wd>, <Wm>
    # SBCS <Wd>, WZR, <Wm>
    # NGCS  <Xd>, <Xm>
    # SBCS <Xd>, XZR, <Xm>
  end

  def test_NOP
    # NOP
    assert_bytes [0x1f,0x20,0x03,0xd5] do |asm|
      asm.nop
    end
  end

  def test_ORN_log_shift
    # ORN  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # ORN  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    assert_bytes [0x41,0x00,0x23,0x2a] do |asm|
      asm.orn w1, w2, w3
    end
    assert_bytes [0x41,0x00,0x23,0xaa] do |asm|
      asm.orn x1, x2, x3
    end
    assert_bytes [0x41,0x1c,0x23,0x2a] do |asm|
      asm.orn w1, w2, w3, lsl(7)
    end
    assert_bytes [0x41,0x1c,0x23,0xaa] do |asm|
      asm.orn x1, x2, x3, lsl(7)
    end
    assert_bytes [0x41,0x1c,0x63,0x2a] do |asm|
      asm.orn w1, w2, w3, lsr(7)
    end
    assert_bytes [0x41,0x1c,0x63,0xaa] do |asm|
      asm.orn x1, x2, x3, lsr(7)
    end
    assert_bytes [0x41,0x1c,0xa3,0x2a] do |asm|
      asm.orn w1, w2, w3, asr(7)
    end
    assert_bytes [0x41,0x1c,0xa3,0xaa] do |asm|
      asm.orn x1, x2, x3, asr(7)
    end
    assert_bytes [0x41,0x1c,0xe3,0x2a] do |asm|
      asm.orn w1, w2, w3, ror(7)
    end
    assert_bytes [0x41,0x1c,0xe3,0xaa] do |asm|
      asm.orn x1, x2, x3, ror(7)
    end
    assert_bytes [0xa3,0x00,0xa7,0xaa] do |asm|
      asm.orn      x3, x5, x7, asr(0)
    end
    assert_bytes [0xa2,0x00,0x3d,0x2a] do |asm|
      asm.orn      w2, w5, w29
    end
  end

  def test_ORR_log_shift
    # ORR  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # ORR  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    assert_bytes [0x41,0x00,0x12,0x32] do |asm|
      asm.orr w1, w2, 0x4000
    end
    assert_bytes [0x41,0x00,0x71,0xb2] do |asm|
      asm.orr x1, x2, 0x8000
    end
    assert_bytes [0xe8,0x03,0x00,0x32] do |asm|
      asm.orr w8, wzr, 0x1
    end
    assert_bytes [0xe8,0x03,0x40,0xb2] do |asm|
      asm.orr x8, xzr, 0x1
    end
    assert_bytes [0x41,0x00,0x03,0x2a] do |asm|
      asm.orr w1, w2, w3
    end
    assert_bytes [0x41,0x00,0x03,0xaa] do |asm|
      asm.orr x1, x2, x3
    end
    assert_bytes [0x41,0x18,0x03,0x2a] do |asm|
      asm.orr w1, w2, w3, lsl(6)
    end
    assert_bytes [0x41,0x18,0x03,0xaa] do |asm|
      asm.orr x1, x2, x3, lsl(6)
    end
    assert_bytes [0x41,0x18,0x43,0x2a] do |asm|
      asm.orr w1, w2, w3, lsr(6)
    end
    assert_bytes [0x41,0x18,0x43,0xaa] do |asm|
      asm.orr x1, x2, x3, lsr(6)
    end
    assert_bytes [0x41,0x18,0x83,0x2a] do |asm|
      asm.orr w1, w2, w3, asr(6)
    end
    assert_bytes [0x41,0x18,0x83,0xaa] do |asm|
      asm.orr x1, x2, x3, asr(6)
    end
    assert_bytes [0x41,0x18,0xc3,0x2a] do |asm|
      asm.orr w1, w2, w3, ror(6)
    end
    assert_bytes [0x41,0x18,0xc3,0xaa] do |asm|
      asm.orr x1, x2, x3, ror(6)
    end
    assert_bytes [0x23,0x3d,0x10,0x32] do |asm|
      asm.orr      w3, w9, 0xffff0000
    end
    assert_bytes [0x5f,0x29,0x03,0x32] do |asm|
      asm.orr      wsp, w10, 0xe00000ff
    end
    assert_bytes [0x49,0x25,0x00,0x32] do |asm|
      asm.orr      w9, w10, 0x3ff
    end
    assert_bytes [0x8b,0x31,0x41,0xb2] do |asm|
      asm.orr      x11, x12, 0x8000000000000fff
    end
    assert_bytes [0x23,0x3d,0x10,0xb2] do |asm|
      asm.orr      x3, x9, 0xffff0000ffff0000
    end
    assert_bytes [0x5f,0x29,0x03,0xb2] do |asm|
      asm.orr      sp, x10, 0xe00000ffe00000ff
    end
    assert_bytes [0x49,0x25,0x00,0xb2] do |asm|
      asm.orr      x9, x10, 0x3ff000003ff
    end
    assert_bytes [0x20,0x78,0x1e,0x32] do |asm|
      asm.orr	w0, w1, 0xfffffffd
    end
    assert_bytes [0xe2,0x7c,0x80,0x2a] do |asm|
      asm.orr      w2, w7, w0, asr(31)
    end
    assert_bytes [0x28,0x31,0x0a,0xaa] do |asm|
      asm.orr      x8, x9, x10, lsl(12)
    end
  end

  def test_PACDA
    skip "Fixme!"
    # PACDA  <Xd>, <Xn|SP>
    # PACDZA  <Xd>
  end

  def test_PACDB
    skip "Fixme!"
    # PACDB  <Xd>, <Xn|SP>
    # PACDZB  <Xd>
  end

  def test_PACGA
    skip "Fixme!"
    # PACGA  <Xd>, <Xn>, <Xm|SP>
  end

  def test_PACIA
    skip "Fixme!"
    # PACIA  <Xd>, <Xn|SP>
    # PACIZA  <Xd>
    # PACIA1716
    # PACIASP
    # PACIAZ
  end

  def test_PACIB
    skip "Fixme!"
    # PACIB  <Xd>, <Xn|SP>
    # PACIZB  <Xd>
    # PACIB1716
    # PACIBSP
    # PACIBZ
  end

  def test_PRFM_imm
    skip "Fixme!"
    # PRFM  (<prfop>|#<imm5>), [<Xn|SP>{, #<pimm>}]
  end

  def test_PRFM_lit
    skip "Fixme!"
    # PRFM  (<prfop>|#<imm5>), <label>
  end

  def test_PRFM_reg
    skip "Fixme!"
    # PRFM  (<prfop>|#<imm5>), [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
  end

  def test_PRFUM
    skip "Fixme!"
    # PRFUM (<prfop>|#<imm5>), [<Xn|SP>{, #<simm>}]
  end

  def test_PSB
    skip "Fixme!"
    # PSB CSYNC
  end

  def test_PSSBB_DSB
    skip "Fixme!"
    # PSSBB
    # DSB #4
  end

  def test_RBIT_int
    skip "Fixme!"
    # RBIT  <Wd>, <Wn>
    # RBIT  <Xd>, <Xn>
  end

  def test_RET
    # RET  {<Xn>}
    asm.ret
    assert_one_insn "ret"
  end

  def test_RETA
    skip "Fixme!"
    # RETAA
    # RETAB
  end

  def test_REV
    skip "Fixme!"
    # REV  <Wd>, <Wn>
    # REV  <Xd>, <Xn>
  end

  def test_REV16_int
    skip "Fixme!"
    # REV16  <Wd>, <Wn>
    # REV16  <Xd>, <Xn>
  end

  def test_REV32_int
    skip "Fixme!"
    # REV32  <Xd>, <Xn>
  end

  def test_REV64_REV
    skip "Fixme!"
    # REV64  <Xd>, <Xn>
    # REV  <Xd>, <Xn>
  end

  def test_RMIF
    skip "Fixme!"
    # RMIF  <Xn>, #<shift>, #<mask>
  end

  def test_ROR_EXTR
    skip "Fixme!"
    # ROR  <Wd>, <Ws>, #<shift>
    # EXTR <Wd>, <Ws>, <Ws>, #<shift>
    # ROR  <Xd>, <Xs>, #<shift>
    # EXTR <Xd>, <Xs>, <Xs>, #<shift>
  end

  def test_ROR_RORV
    skip "Fixme!"
    # ROR  <Wd>, <Wn>, <Wm>
    # RORV <Wd>, <Wn>, <Wm>
    # ROR  <Xd>, <Xn>, <Xm>
    # RORV <Xd>, <Xn>, <Xm>
  end

  def test_RORV
    skip "Fixme!"
    # RORV  <Wd>, <Wn>, <Wm>
    # RORV  <Xd>, <Xn>, <Xm>
  end

  def test_SB
    skip "Fixme!"
    # SB
  end

  def test_SBC
    skip "Fixme!"
    # SBC  <Wd>, <Wn>, <Wm>
    # SBC  <Xd>, <Xn>, <Xm>
  end

  def test_SBCS
    skip "Fixme!"
    # SBCS  <Wd>, <Wn>, <Wm>
    # SBCS  <Xd>, <Xn>, <Xm>
  end

  def test_SBFIZ_SBFM
    skip "Fixme!"
    # SBFIZ  <Wd>, <Wn>, #<lsb>, #<width>
    # SBFM <Wd>, <Wn>, #(-<lsb> MOD 32), #(<width>-1)
    # SBFIZ  <Xd>, <Xn>, #<lsb>, #<width>
    # SBFM <Xd>, <Xn>, #(-<lsb> MOD 64), #(<width>-1)
  end

  def test_SBFM
    skip "Fixme!"
    # SBFM  <Wd>, <Wn>, #<immr>, #<imms>
    # SBFM  <Xd>, <Xn>, #<immr>, #<imms>
  end

  def test_SBFX_SBFM
    skip "Fixme!"
    # SBFX  <Wd>, <Wn>, #<lsb>, #<width>
    # SBFM <Wd>, <Wn>, #<lsb>, #(<lsb>+<width>-1)
    # SBFX  <Xd>, <Xn>, #<lsb>, #<width>
    # SBFM <Xd>, <Xn>, #<lsb>, #(<lsb>+<width>-1)
  end

  def test_SDIV
    skip "Fixme!"
    # SDIV  <Wd>, <Wn>, <Wm>
    # SDIV  <Xd>, <Xn>, <Xm>
  end

  def test_SETF
    skip "Fixme!"
    # SETF8  <Wn>
    # SETF16  <Wn>
  end

  def test_SETGP
    skip "Fixme!"
    # SETGE  [<Xd>]!, <Xn>!, <Xs>
    # SETGM  [<Xd>]!, <Xn>!, <Xs>
    # SETGP  [<Xd>]!, <Xn>!, <Xs>
  end

  def test_SETGPN
    skip "Fixme!"
    # SETGEN  [<Xd>]!, <Xn>!, <Xs>
    # SETGMN  [<Xd>]!, <Xn>!, <Xs>
    # SETGPN  [<Xd>]!, <Xn>!, <Xs>
  end

  def test_SETGPT
    skip "Fixme!"
    # SETGET  [<Xd>]!, <Xn>!, <Xs>
    # SETGMT  [<Xd>]!, <Xn>!, <Xs>
    # SETGPT  [<Xd>]!, <Xn>!, <Xs>
  end

  def test_SETGPTN
    skip "Fixme!"
    # SETGETN  [<Xd>]!, <Xn>!, <Xs>
    # SETGMTN  [<Xd>]!, <Xn>!, <Xs>
    # SETGPTN  [<Xd>]!, <Xn>!, <Xs>
  end

  def test_SETP
    skip "Fixme!"
    # SETE  [<Xd>]!, <Xn>!, <Xs>
    # SETM  [<Xd>]!, <Xn>!, <Xs>
    # SETP  [<Xd>]!, <Xn>!, <Xs>
  end

  def test_SETPN
    skip "Fixme!"
    # SETEN  [<Xd>]!, <Xn>!, <Xs>
    # SETMN  [<Xd>]!, <Xn>!, <Xs>
    # SETPN  [<Xd>]!, <Xn>!, <Xs>
  end

  def test_SETPT
    skip "Fixme!"
    # SETET  [<Xd>]!, <Xn>!, <Xs>
    # SETMT  [<Xd>]!, <Xn>!, <Xs>
    # SETPT  [<Xd>]!, <Xn>!, <Xs>
  end

  def test_SETPTN
    skip "Fixme!"
    # SETETN  [<Xd>]!, <Xn>!, <Xs>
    # SETMTN  [<Xd>]!, <Xn>!, <Xs>
    # SETPTN  [<Xd>]!, <Xn>!, <Xs>
  end

  def test_SEV
    skip "Fixme!"
    # SEV
  end

  def test_SEVL
    skip "Fixme!"
    # SEVL
  end

  def test_SMADDL
    skip "Fixme!"
    # SMADDL  <Xd>, <Wn>, <Wm>, <Xa>
  end

  def test_SMC
    skip "Fixme!"
    # SMC  #<imm>
  end

  def test_SMNEGL_SMSUBL
    skip "Fixme!"
    # SMNEGL  <Xd>, <Wn>, <Wm>
    # SMSUBL <Xd>, <Wn>, <Wm>, XZR
  end

  def test_SMSUBL
    skip "Fixme!"
    # SMSUBL  <Xd>, <Wn>, <Wm>, <Xa>
  end

  def test_SMULH
    skip "Fixme!"
    # SMULH  <Xd>, <Xn>, <Xm>
  end

  def test_SMULL_SMADDL
    skip "Fixme!"
    # SMULL  <Xd>, <Wn>, <Wm>
    # SMADDL <Xd>, <Wn>, <Wm>, XZR
  end

  def test_SSBB_DSB
    skip "Fixme!"
    # SSBB
    # DSB #0
  end

  def test_ST2G
    skip "Fixme!"
    # ST2G  <Xt|SP>, [<Xn|SP>], #<simm>
    # ST2G  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # ST2G  <Xt|SP>, [<Xn|SP>{, #<simm>}]
  end

  def test_ST64B
    skip "Fixme!"
    # ST64B  <Xt>, [<Xn|SP> {,#0}]
  end

  def test_ST64BV
    skip "Fixme!"
    # ST64BV  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_ST64BV0
    skip "Fixme!"
    # ST64BV0  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_STADD_LDADD
    skip "Fixme!"
    # STADD  <Ws>, [<Xn|SP>]
    # LDADD <Ws>, WZR, [<Xn|SP>]
    # STADDL  <Ws>, [<Xn|SP>]
    # LDADDL <Ws>, WZR, [<Xn|SP>]
    # STADD  <Xs>, [<Xn|SP>]
    # LDADD <Xs>, XZR, [<Xn|SP>]
    # STADDL  <Xs>, [<Xn|SP>]
    # LDADDL <Xs>, XZR, [<Xn|SP>]
  end

  def test_STADDB_LDADDB
    skip "Fixme!"
    # STADDB  <Ws>, [<Xn|SP>]
    # LDADDB <Ws>, WZR, [<Xn|SP>]
    # STADDLB  <Ws>, [<Xn|SP>]
    # LDADDLB <Ws>, WZR, [<Xn|SP>]
  end

  def test_STADDH_LDADDH
    skip "Fixme!"
    # STADDH  <Ws>, [<Xn|SP>]
    # LDADDH <Ws>, WZR, [<Xn|SP>]
    # STADDLH  <Ws>, [<Xn|SP>]
    # LDADDLH <Ws>, WZR, [<Xn|SP>]
  end

  def test_STCLR_LDCLR
    skip "Fixme!"
    # STCLR  <Ws>, [<Xn|SP>]
    # LDCLR <Ws>, WZR, [<Xn|SP>]
    # STCLRL  <Ws>, [<Xn|SP>]
    # LDCLRL <Ws>, WZR, [<Xn|SP>]
    # STCLR  <Xs>, [<Xn|SP>]
    # LDCLR <Xs>, XZR, [<Xn|SP>]
    # STCLRL  <Xs>, [<Xn|SP>]
    # LDCLRL <Xs>, XZR, [<Xn|SP>]
  end

  def test_STCLRB_LDCLRB
    skip "Fixme!"
    # STCLRB  <Ws>, [<Xn|SP>]
    # LDCLRB <Ws>, WZR, [<Xn|SP>]
    # STCLRLB  <Ws>, [<Xn|SP>]
    # LDCLRLB <Ws>, WZR, [<Xn|SP>]
  end

  def test_STCLRH_LDCLRH
    skip "Fixme!"
    # STCLRH  <Ws>, [<Xn|SP>]
    # LDCLRH <Ws>, WZR, [<Xn|SP>]
    # STCLRLH  <Ws>, [<Xn|SP>]
    # LDCLRLH <Ws>, WZR, [<Xn|SP>]
  end

  def test_STEOR_LDEOR
    skip "Fixme!"
    # STEOR  <Ws>, [<Xn|SP>]
    # LDEOR <Ws>, WZR, [<Xn|SP>]
    # STEORL  <Ws>, [<Xn|SP>]
    # LDEORL <Ws>, WZR, [<Xn|SP>]
    # STEOR  <Xs>, [<Xn|SP>]
    # LDEOR <Xs>, XZR, [<Xn|SP>]
    # STEORL  <Xs>, [<Xn|SP>]
    # LDEORL <Xs>, XZR, [<Xn|SP>]
  end

  def test_STEORB_LDEORB
    skip "Fixme!"
    # STEORB  <Ws>, [<Xn|SP>]
    # LDEORB <Ws>, WZR, [<Xn|SP>]
    # STEORLB  <Ws>, [<Xn|SP>]
    # LDEORLB <Ws>, WZR, [<Xn|SP>]
  end

  def test_STEORH_LDEORH
    skip "Fixme!"
    # STEORH  <Ws>, [<Xn|SP>]
    # LDEORH <Ws>, WZR, [<Xn|SP>]
    # STEORLH  <Ws>, [<Xn|SP>]
    # LDEORLH <Ws>, WZR, [<Xn|SP>]
  end

  def test_STG
    skip "Fixme!"
    # STG  <Xt|SP>, [<Xn|SP>], #<simm>
    # STG  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # STG  <Xt|SP>, [<Xn|SP>{, #<simm>}]
  end

  def test_STGM
    skip "Fixme!"
    # STGM  <Xt>, [<Xn|SP>]
  end

  def test_STGP
    skip "Fixme!"
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
  end

  def test_STLLR
    skip "Fixme!"
    # STLLR  <Wt>, [<Xn|SP>{,#0}]
    # STLLR  <Xt>, [<Xn|SP>{,#0}]
  end

  def test_STLLRB
    skip "Fixme!"
    # STLLRB  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_STLLRH
    skip "Fixme!"
    # STLLRH  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_STLR
    skip "Fixme!"
    # STLR  <Wt>, [<Xn|SP>{,#0}]
    # STLR  <Xt>, [<Xn|SP>{,#0}]
  end

  def test_STLRB
    skip "Fixme!"
    # STLRB  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_STLRH
    skip "Fixme!"
    # STLRH  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_STLUR_gen
    skip "Fixme!"
    # STLUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # STLUR  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_STLURB
    skip "Fixme!"
    # STLURB  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_STLURH
    skip "Fixme!"
    # STLURH  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_STLXP
    skip "Fixme!"
    # STLXP  <Ws>, <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # STLXP  <Ws>, <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
  end

  def test_STLXR
    skip "Fixme!"
    # STLXR  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # STLXR  <Ws>, <Xt>, [<Xn|SP>{,#0}]
  end

  def test_STLXRB
    skip "Fixme!"
    # STLXRB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
  end

  def test_STLXRH
    skip "Fixme!"
    # STLXRH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
  end

  def test_STNP_gen
    skip "Fixme!"
    # STNP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # STNP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
  end

  def test_STP_gen
    skip "Fixme!"
    # STP  <Wt1>, <Wt2>, [<Xn|SP>], #<imm>
    # STP  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # STP  <Wt1>, <Wt2>, [<Xn|SP>, #<imm>]!
    # STP  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # STP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # STP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
  end

  def test_STR_imm_gen
    skip "Fixme!"
    # STR  <Wt>, [<Xn|SP>], #<simm>
    # STR  <Xt>, [<Xn|SP>], #<simm>
    # STR  <Wt>, [<Xn|SP>, #<simm>]!
    # STR  <Xt>, [<Xn|SP>, #<simm>]!
    # STR  <Wt>, [<Xn|SP>{, #<pimm>}]
    # STR  <Xt>, [<Xn|SP>{, #<pimm>}]
  end

  def test_STR_reg_gen
    skip "Fixme!"
    # STR  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    # STR  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
  end

  def test_STRB_imm
    skip "Fixme!"
    # STRB  <Wt>, [<Xn|SP>], #<simm>
    # STRB  <Wt>, [<Xn|SP>, #<simm>]!
    # STRB  <Wt>, [<Xn|SP>{, #<pimm>}]
  end

  def test_STRB_reg
    skip "Fixme!"
    # STRB  <Wt>, [<Xn|SP>, (<Wm>|<Xm>), <extend> {<amount>}]
    # STRB  <Wt>, [<Xn|SP>, <Xm>{, LSL <amount>}]
  end

  def test_STRH_imm
    skip "Fixme!"
    # STRH  <Wt>, [<Xn|SP>], #<simm>
    # STRH  <Wt>, [<Xn|SP>, #<simm>]!
    # STRH  <Wt>, [<Xn|SP>{, #<pimm>}]
  end

  def test_STRH_reg
    skip "Fixme!"
    # STRH  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
  end

  def test_STSET_LDSET
    skip "Fixme!"
    # STSET  <Ws>, [<Xn|SP>]
    # LDSET <Ws>, WZR, [<Xn|SP>]
    # STSETL  <Ws>, [<Xn|SP>]
    # LDSETL <Ws>, WZR, [<Xn|SP>]
    # STSET  <Xs>, [<Xn|SP>]
    # LDSET <Xs>, XZR, [<Xn|SP>]
    # STSETL  <Xs>, [<Xn|SP>]
    # LDSETL <Xs>, XZR, [<Xn|SP>]
  end

  def test_STSETB_LDSETB
    skip "Fixme!"
    # STSETB  <Ws>, [<Xn|SP>]
    # LDSETB <Ws>, WZR, [<Xn|SP>]
    # STSETLB  <Ws>, [<Xn|SP>]
    # LDSETLB <Ws>, WZR, [<Xn|SP>]
  end

  def test_STSETH_LDSETH
    skip "Fixme!"
    # STSETH  <Ws>, [<Xn|SP>]
    # LDSETH <Ws>, WZR, [<Xn|SP>]
    # STSETLH  <Ws>, [<Xn|SP>]
    # LDSETLH <Ws>, WZR, [<Xn|SP>]
  end

  def test_STSMAX_LDSMAX
    skip "Fixme!"
    # STSMAX  <Ws>, [<Xn|SP>]
    # LDSMAX <Ws>, WZR, [<Xn|SP>]
    # STSMAXL  <Ws>, [<Xn|SP>]
    # LDSMAXL <Ws>, WZR, [<Xn|SP>]
    # STSMAX  <Xs>, [<Xn|SP>]
    # LDSMAX <Xs>, XZR, [<Xn|SP>]
    # STSMAXL  <Xs>, [<Xn|SP>]
    # LDSMAXL <Xs>, XZR, [<Xn|SP>]
  end

  def test_STSMAXB_LDSMAXB
    skip "Fixme!"
    # STSMAXB  <Ws>, [<Xn|SP>]
    # LDSMAXB <Ws>, WZR, [<Xn|SP>]
    # STSMAXLB  <Ws>, [<Xn|SP>]
    # LDSMAXLB <Ws>, WZR, [<Xn|SP>]
  end

  def test_STSMAXH_LDSMAXH
    skip "Fixme!"
    # STSMAXH  <Ws>, [<Xn|SP>]
    # LDSMAXH <Ws>, WZR, [<Xn|SP>]
    # STSMAXLH  <Ws>, [<Xn|SP>]
    # LDSMAXLH <Ws>, WZR, [<Xn|SP>]
  end

  def test_STSMIN_LDSMIN
    skip "Fixme!"
    # STSMIN  <Ws>, [<Xn|SP>]
    # LDSMIN <Ws>, WZR, [<Xn|SP>]
    # STSMINL  <Ws>, [<Xn|SP>]
    # LDSMINL <Ws>, WZR, [<Xn|SP>]
    # STSMIN  <Xs>, [<Xn|SP>]
    # LDSMIN <Xs>, XZR, [<Xn|SP>]
    # STSMINL  <Xs>, [<Xn|SP>]
    # LDSMINL <Xs>, XZR, [<Xn|SP>]
  end

  def test_STSMINB_LDSMINB
    skip "Fixme!"
    # STSMINB  <Ws>, [<Xn|SP>]
    # LDSMINB <Ws>, WZR, [<Xn|SP>]
    # STSMINLB  <Ws>, [<Xn|SP>]
    # LDSMINLB <Ws>, WZR, [<Xn|SP>]
  end

  def test_STSMINH_LDSMINH
    skip "Fixme!"
    # STSMINH  <Ws>, [<Xn|SP>]
    # LDSMINH <Ws>, WZR, [<Xn|SP>]
    # STSMINLH  <Ws>, [<Xn|SP>]
    # LDSMINLH <Ws>, WZR, [<Xn|SP>]
  end

  def test_STTR
    skip "Fixme!"
    # STTR  <Wt>, [<Xn|SP>{, #<simm>}]
    # STTR  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_STTRB
    skip "Fixme!"
    # STTRB  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_STTRH
    skip "Fixme!"
    # STTRH  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_STUMAX_LDUMAX
    skip "Fixme!"
    # STUMAX  <Ws>, [<Xn|SP>]
    # LDUMAX <Ws>, WZR, [<Xn|SP>]
    # STUMAXL  <Ws>, [<Xn|SP>]
    # LDUMAXL <Ws>, WZR, [<Xn|SP>]
    # STUMAX  <Xs>, [<Xn|SP>]
    # LDUMAX <Xs>, XZR, [<Xn|SP>]
    # STUMAXL  <Xs>, [<Xn|SP>]
    # LDUMAXL <Xs>, XZR, [<Xn|SP>]
  end

  def test_STUMAXB_LDUMAXB
    skip "Fixme!"
    # STUMAXB  <Ws>, [<Xn|SP>]
    # LDUMAXB <Ws>, WZR, [<Xn|SP>]
    # STUMAXLB  <Ws>, [<Xn|SP>]
    # LDUMAXLB <Ws>, WZR, [<Xn|SP>]
  end

  def test_STUMAXH_LDUMAXH
    skip "Fixme!"
    # STUMAXH  <Ws>, [<Xn|SP>]
    # LDUMAXH <Ws>, WZR, [<Xn|SP>]
    # STUMAXLH  <Ws>, [<Xn|SP>]
    # LDUMAXLH <Ws>, WZR, [<Xn|SP>]
  end

  def test_STUMIN_LDUMIN
    skip "Fixme!"
    # STUMIN  <Ws>, [<Xn|SP>]
    # LDUMIN <Ws>, WZR, [<Xn|SP>]
    # STUMINL  <Ws>, [<Xn|SP>]
    # LDUMINL <Ws>, WZR, [<Xn|SP>]
    # STUMIN  <Xs>, [<Xn|SP>]
    # LDUMIN <Xs>, XZR, [<Xn|SP>]
    # STUMINL  <Xs>, [<Xn|SP>]
    # LDUMINL <Xs>, XZR, [<Xn|SP>]
  end

  def test_STUMINB_LDUMINB
    skip "Fixme!"
    # STUMINB  <Ws>, [<Xn|SP>]
    # LDUMINB <Ws>, WZR, [<Xn|SP>]
    # STUMINLB  <Ws>, [<Xn|SP>]
    # LDUMINLB <Ws>, WZR, [<Xn|SP>]
  end

  def test_STUMINH_LDUMINH
    skip "Fixme!"
    # STUMINH  <Ws>, [<Xn|SP>]
    # LDUMINH <Ws>, WZR, [<Xn|SP>]
    # STUMINLH  <Ws>, [<Xn|SP>]
    # LDUMINLH <Ws>, WZR, [<Xn|SP>]
  end

  def test_STUR_gen
    skip "Fixme!"
    # STUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # STUR  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_STURB
    skip "Fixme!"
    # STURB  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_STURH
    skip "Fixme!"
    # STURH  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_STXP
    # STXP  <Ws>, <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # STXP  <Ws>, <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
    assert_bytes [0x22,0x18,0x21,0xc8] do |asm|
      asm.stxp   w1, x2, x6, [x1]
    end
    assert_bytes [0x22,0x18,0x21,0x88] do |asm|
      asm.stxp   w1, w2, w6, [x1]
    end
    assert_bytes [0xcc,0x35,0x2b,0x88] do |asm|
      asm.stxp     w11, w12, w13, [x14]
    end
    assert_bytes [0xf7,0x39,0x3f,0xc8] do |asm|
      asm.stxp     wzr, x23, x14, [x15]
    end
  end

  def test_STXR
    # STXR  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # STXR  <Ws>, <Xt>, [<Xn|SP>{,#0}]
    assert_bytes [0x64,0x7c,0x01,0xc8] do |asm|
      asm.stxr   w1, x4, [x3]
    end
    assert_bytes [0x64,0x7c,0x01,0x88] do |asm|
      asm.stxr   w1, w4, [x3]
    end
    assert_bytes [0xe4,0x7f,0x1f,0x88] do |asm|
      asm.stxr     wzr, w4, [sp]
    end
    assert_bytes [0xe6,0x7c,0x05,0xc8] do |asm|
      asm.stxr     w5, x6, [x7]
    end
  end

  def test_STXRB
    # STXRB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    assert_bytes [0x64,0x7c,0x01,0x08] do |asm|
      asm.stxrb  w1, w4, [x3]
    end
    assert_bytes [0x62,0x7c,0x01,0x08] do |asm|
      asm.stxrb    w1, w2, [x3]
    end
  end

  def test_STXRH
    # STXRH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # stxrh w1, w4, [x3]
    assert_bytes [0x64,0x7c,0x01,0x48] do |asm|
      asm.stxrh  w1, w4, [x3]
    end
    assert_bytes [0x83,0x7c,0x02,0x48] do |asm|
      asm.stxrh    w2, w3, [x4]
    end
  end

  def test_STZ2G
    skip "Fixme!"
    # STZ2G  <Xt|SP>, [<Xn|SP>], #<simm>
    # STZ2G  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # STZ2G  <Xt|SP>, [<Xn|SP>{, #<simm>}]
  end

  def test_STZG
    skip "Fixme!"
    # STZG  <Xt|SP>, [<Xn|SP>], #<simm>
    # STZG  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # STZG  <Xt|SP>, [<Xn|SP>{, #<simm>}]
  end

  def test_STZGM
    # STZGM  <Xt>, [<Xn|SP>]
    # stzgm  x3, [x1]
    # stzgm  x3, [sp]
    assert_bytes [35, 0, 32, 217] do |asm|
      asm.stzgm x3, [x1]
    end
    assert_bytes [227, 3, 32, 217] do |asm|
      asm.stzgm x3, [sp]
    end
  end

  def test_SUB_all
    assert_bytes [0x82,0x08,0x25,0xcb] do |asm|
      asm.sub      x2, x4, w5, uxtb(2)
    end
    assert_bytes [0xf4,0x33,0x33,0xcb] do |asm|
      asm.sub      x20, sp, w19, uxth(4)
    end
    assert_bytes [0x2c,0x40,0x34,0xcb] do |asm|
      asm.sub      x12, x1, w20, uxtw
    end
    assert_bytes [0x74,0x60,0x2d,0xcb] do |asm|
      asm.sub      x20, x3, x13, uxtx
    end
    assert_bytes [0x31,0x83,0x34,0xcb] do |asm|
      asm.sub      x17, x25, w20, sxtb
    end
    assert_bytes [0xb2,0xa1,0x33,0xcb] do |asm|
      asm.sub      x18, x13, w19, sxth
    end
    assert_bytes [0x5f,0xc0,0x23,0xcb] do |asm|
      asm.sub      sp, x2, w3, sxtw
    end
    assert_bytes [0xa3,0xe0,0x29,0xcb] do |asm|
      asm.sub      x3, x5, x9, sxtx
    end
    assert_bytes [0xa2,0x00,0x27,0x4b] do |asm|
      asm.sub      w2, w5, w7, uxtb
    end
    assert_bytes [0xf5,0x21,0x31,0x4b] do |asm|
      asm.sub      w21, w15, w17, uxth
    end
    assert_bytes [0xbe,0x43,0x3f,0x4b] do |asm|
      asm.sub      w30, w29, wzr, uxtw
    end
    assert_bytes [0x33,0x62,0x21,0x4b] do |asm|
      asm.sub      w19, w17, w1, uxtx
    end
    assert_bytes [0xa2,0x80,0x21,0x4b] do |asm|
      asm.sub      w2, w5, w1, sxtb
    end
    assert_bytes [0xfa,0xa3,0x33,0x4b] do |asm|
      asm.sub      w26, wsp, w19, sxth
    end
    assert_bytes [0x5f,0xc0,0x23,0x4b] do |asm|
      asm.sub      wsp, w2, w3, sxtw
    end
    assert_bytes [0x62,0xe0,0x25,0x4b] do |asm|
      asm.sub      w2, w3, w5, sxtx
    end
    assert_bytes [0x7f,0x70,0x27,0xcb] do |asm|
      asm.sub      sp, x3, x7, lsl(4)
    end
    assert_bytes [0xe0,0xb7,0x3f,0x51] do |asm|
      asm.sub      w0, wsp, 4077
    end
    assert_bytes [0x84,0x8a,0x48,0x51] do |asm|
      asm.sub      w4, w20, 546, lsl(12)
    end
    assert_bytes [0xff,0x83,0x04,0xd1] do |asm|
      asm.sub      sp, sp, 288
    end
    assert_bytes [0x7f,0x42,0x00,0x51] do |asm|
      asm.sub      wsp, w19, 16
    end
    assert_bytes [0xa3,0x00,0x07,0x4b] do |asm|
      asm.sub      w3, w5, w7
    end
    assert_bytes [0x7f,0x00,0x05,0x4b] do |asm|
      asm.sub      wzr, w3, w5
    end
    assert_bytes [0xc4,0x00,0x1f,0x4b] do |asm|
      asm.sub      w4, w6, wzr
    end
    assert_bytes [0xab,0x01,0x0f,0x4b] do |asm|
      asm.sub      w11, w13, w15
    end
    assert_bytes [0x69,0x28,0x1f,0x4b] do |asm|
      asm.sub      w9, w3, wzr, lsl(10)
    end
    assert_bytes [0xb1,0x7f,0x14,0x4b] do |asm|
      asm.sub      w17, w29, w20, lsl(31)
    end
    assert_bytes [0xd5,0x02,0x57,0x4b] do |asm|
      asm.sub      w21, w22, w23, lsr(0)
    end
    assert_bytes [0x38,0x4b,0x5a,0x4b] do |asm|
      asm.sub      w24, w25, w26, lsr(18)
    end
    assert_bytes [0x9b,0x7f,0x5d,0x4b] do |asm|
      asm.sub      w27, w28, w29, lsr(31)
    end
    assert_bytes [0x62,0x00,0x84,0x4b] do |asm|
      asm.sub      w2, w3, w4, asr(0)
    end
    assert_bytes [0xc5,0x54,0x87,0x4b] do |asm|
      asm.sub      w5, w6, w7, asr(21)
    end
    assert_bytes [0x28,0x7d,0x8a,0x4b] do |asm|
      asm.sub      w8, w9, w10, asr(31)
    end
    assert_bytes [0xa3,0x00,0x07,0xcb] do |asm|
      asm.sub      x3, x5, x7
    end
    assert_bytes [0x7f,0x00,0x05,0xcb] do |asm|
      asm.sub      xzr, x3, x5
    end
    assert_bytes [0xc4,0x00,0x1f,0xcb] do |asm|
      asm.sub      x4, x6, xzr
    end
    assert_bytes [0xab,0x01,0x0f,0xcb] do |asm|
      asm.sub      x11, x13, x15
    end
    assert_bytes [0x69,0x28,0x1f,0xcb] do |asm|
      asm.sub      x9, x3, xzr, lsl(10)
    end
    assert_bytes [0xb1,0xff,0x14,0xcb] do |asm|
      asm.sub      x17, x29, x20, lsl(63)
    end
    assert_bytes [0xd5,0x02,0x57,0xcb] do |asm|
      asm.sub      x21, x22, x23, lsr(0)
    end
    assert_bytes [0x38,0x4b,0x5a,0xcb] do |asm|
      asm.sub      x24, x25, x26, lsr(18)
    end
    assert_bytes [0x9b,0xff,0x5d,0xcb] do |asm|
      asm.sub      x27, x28, x29, lsr(63)
    end
    assert_bytes [0x62,0x00,0x84,0xcb] do |asm|
      asm.sub      x2, x3, x4, asr(0)
    end
    assert_bytes [0xc5,0x54,0x87,0xcb] do |asm|
      asm.sub      x5, x6, x7, asr(21)
    end
    assert_bytes [0x28,0xfd,0x8a,0xcb] do |asm|
      asm.sub      x8, x9, x10, asr(63)
    end
  end

  def test_SUBG
    # SUBG  <Xd|SP>, <Xn|SP>, #<uimm6>, #<uimm4>
    assert_bytes [0x41, 0x1c, 0x83, 0xd1] do |asm|
      asm.subg x1, x2, 3, 0b111
    end
  end

  def test_SUBP
    # SUBP  <Xd>, <Xn|SP>, <Xm|SP>
    assert_bytes [0x43, 0, 0xc3, 0x9a] do |asm|
      asm.subp x1, x2, x3
    end
  end

  def test_SUBPS
    # SUBPS  <Xd>, <Xn|SP>, <Xm|SP>
    assert_bytes [0x41, 0, 0xc3, 0xba] do |asm|
      asm.subps x1, x2, x3
    end
  end

  def test_SUBS_all
    # SUBS  <Wd>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # SUBS  <Xd>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    # SUBS  <Wd>, <Wn|WSP>, #<imm>{, <shift>}
    # SUBS  <Xd>, <Xn|SP>, #<imm>{, <shift>}
    # SUBS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # SUBS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    assert_bytes [0x82,0x08,0x25,0xeb] do |asm|
      asm.subs     x2, x4, w5, uxtb(2)
    end
    assert_bytes [0xf4,0x33,0x33,0xeb] do |asm|
      asm.subs     x20, sp, w19, uxth(4)
    end
    assert_bytes [0x2c,0x40,0x34,0xeb] do |asm|
      asm.subs     x12, x1, w20, uxtw
    end
    assert_bytes [0x74,0x60,0x2d,0xeb] do |asm|
      asm.subs     x20, x3, x13, uxtx
    end
    assert_bytes [0xf2,0xa3,0x33,0xeb] do |asm|
      asm.subs     x18, sp, w19, sxth
    end
    assert_bytes [0xa3,0xe8,0x29,0xeb] do |asm|
      asm.subs     x3, x5, x9, sxtx(2)
    end
    assert_bytes [0xa2,0x00,0x27,0x6b] do |asm|
      asm.subs     w2, w5, w7, uxtb
    end
    assert_bytes [0xf5,0x21,0x31,0x6b] do |asm|
      asm.subs     w21, w15, w17, uxth
    end
    assert_bytes [0xbe,0x43,0x3f,0x6b] do |asm|
      asm.subs     w30, w29, wzr, uxtw
    end
    assert_bytes [0x33,0x62,0x21,0x6b] do |asm|
      asm.subs     w19, w17, w1, uxtx
    end
    assert_bytes [0xa2,0x84,0x21,0x6b] do |asm|
      asm.subs     w2, w5, w1, sxtb(1)
    end
    assert_bytes [0xfa,0xa3,0x33,0x6b] do |asm|
      asm.subs     w26, wsp, w19, sxth
    end
    assert_bytes [0x62,0xe0,0x25,0x6b] do |asm|
      asm.subs     w2, w3, w5, sxtx
    end
    assert_bytes [0xe3,0x6b,0x29,0xeb] do |asm|
      asm.subs     x3, sp, x9, lsl(2)
    end
    assert_bytes [0xe4,0xbb,0x3b,0xf1] do |asm|
      asm.subs     x4, sp, 3822
    end
    assert_bytes [0xa3,0x00,0x07,0x6b] do |asm|
      asm.subs     w3, w5, w7
    end
    assert_bytes [0xc4,0x00,0x1f,0x6b] do |asm|
      asm.subs     w4, w6, wzr
    end
    assert_bytes [0xab,0x01,0x0f,0x6b] do |asm|
      asm.subs     w11, w13, w15
    end
    assert_bytes [0x69,0x28,0x1f,0x6b] do |asm|
      asm.subs     w9, w3, wzr, lsl(10)
    end
    assert_bytes [0xb1,0x7f,0x14,0x6b] do |asm|
      asm.subs     w17, w29, w20, lsl(31)
    end
    assert_bytes [0xd5,0x02,0x57,0x6b] do |asm|
      asm.subs     w21, w22, w23, lsr(0)
    end
    assert_bytes [0x38,0x4b,0x5a,0x6b] do |asm|
      asm.subs     w24, w25, w26, lsr(18)
    end
    assert_bytes [0x9b,0x7f,0x5d,0x6b] do |asm|
      asm.subs     w27, w28, w29, lsr(31)
    end
    assert_bytes [0x62,0x00,0x84,0x6b] do |asm|
      asm.subs     w2, w3, w4, asr(0)
    end
    assert_bytes [0xc5,0x54,0x87,0x6b] do |asm|
      asm.subs     w5, w6, w7, asr(21)
    end
    assert_bytes [0x28,0x7d,0x8a,0x6b] do |asm|
      asm.subs     w8, w9, w10, asr(31)
    end
    assert_bytes [0xa3,0x00,0x07,0xeb] do |asm|
      asm.subs     x3, x5, x7
    end
    assert_bytes [0xc4,0x00,0x1f,0xeb] do |asm|
      asm.subs     x4, x6, xzr
    end
    assert_bytes [0xab,0x01,0x0f,0xeb] do |asm|
      asm.subs     x11, x13, x15
    end
    assert_bytes [0x69,0x28,0x1f,0xeb] do |asm|
      asm.subs     x9, x3, xzr, lsl(10)
    end
    assert_bytes [0xb1,0xff,0x14,0xeb] do |asm|
      asm.subs     x17, x29, x20, lsl(63)
    end
    assert_bytes [0xd5,0x02,0x57,0xeb] do |asm|
      asm.subs     x21, x22, x23, lsr(0)
    end
    assert_bytes [0x38,0x4b,0x5a,0xeb] do |asm|
      asm.subs     x24, x25, x26, lsr(18)
    end
    assert_bytes [0x9b,0xff,0x5d,0xeb] do |asm|
      asm.subs     x27, x28, x29, lsr(63)
    end
    assert_bytes [0x62,0x00,0x84,0xeb] do |asm|
      asm.subs     x2, x3, x4, asr(0)
    end
    assert_bytes [0xc5,0x54,0x87,0xeb] do |asm|
      asm.subs     x5, x6, x7, asr(21)
    end
    assert_bytes [0x28,0xfd,0x8a,0xeb] do |asm|
      asm.subs     x8, x9, x10, asr(63)
    end
  end

  def test_SVC
    # SVC  #<imm>
    assert_bytes [0x01,0x00,0x00,0xd4] do |asm|
      asm.svc      0
    end
  end

  def test_SWP
    # SWP  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0x20,0xf8] do |asm|
      asm.swp   x0, x1, [x2]
    end
    assert_bytes [0x41,0x80,0x20,0xb8] do |asm|
      asm.swp w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0x22,0xb8] do |asm|
      asm.swp w2, w3, [sp]
    end
    assert_bytes [0x41,0x80,0x20,0xf8] do |asm|
      asm.swp x0, x1, [x2]
    end
    assert_bytes [0xe3,0x83,0x22,0xf8] do |asm|
      asm.swp x2, x3, [sp]
    end
    # SWPA  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0xa0,0xb8] do |asm|
      asm.swpa w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0xa2,0xb8] do |asm|
      asm.swpa w2, w3, [sp]
    end
    assert_bytes [0x41,0x80,0xa0,0xf8] do |asm|
      asm.swpa x0, x1, [x2]
    end
    assert_bytes [0xe3,0x83,0xa2,0xf8] do |asm|
      asm.swpa x2, x3, [sp]
    end
    # SWPAL  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0xe1,0x83,0xe0,0xf8] do |asm|
      asm.swpal x0, x1, [sp]
    end
    assert_bytes [0x41,0x80,0xe0,0xb8] do |asm|
      asm.swpal w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0xe2,0xb8] do |asm|
      asm.swpal w2, w3, [sp]
    end
    assert_bytes [0x41,0x80,0xe0,0xf8] do |asm|
      asm.swpal x0, x1, [x2]
    end
    assert_bytes [0xe3,0x83,0xe2,0xf8] do |asm|
      asm.swpal x2, x3, [sp]
    end
    # SWPL  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0x60,0xb8] do |asm|
      asm.swpl w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0x62,0xb8] do |asm|
      asm.swpl w2, w3, [sp]
    end
    assert_bytes [0x41,0x80,0x60,0xf8] do |asm|
      asm.swpl x0, x1, [x2]
    end
    assert_bytes [0xe3,0x83,0x62,0xf8] do |asm|
      asm.swpl x2, x3, [sp]
    end
    # SWP  <Xs>, <Xt>, [<Xn|SP>]
    # SWPA  <Xs>, <Xt>, [<Xn|SP>]
    # SWPAL  <Xs>, <Xt>, [<Xn|SP>]
    # SWPL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_SWPB
    # SWPAB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0xa0,0x38] do |asm|
      asm.swpab w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0xa2,0x38] do |asm|
      asm.swpab w2, w3, [sp]
    end
    # SWPALB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0xe0,0x38] do |asm|
      asm.swpalb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0xe2,0x38] do |asm|
      asm.swpalb w2, w3, [sp]
    end
    # SWPB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0x20,0x38] do |asm|
      asm.swpb  w0, w1, [x2]
    end
    assert_bytes [0x41,0x80,0x20,0x38] do |asm|
      asm.swpb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0x22,0x38] do |asm|
      asm.swpb w2, w3, [sp]
    end
    # SWPLB  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0x60,0x38] do |asm|
      asm.swplb w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0x62,0x38] do |asm|
      asm.swplb w2, w3, [sp]
    end
  end

  def test_SWPH
    # SWPAH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0xa0,0x78] do |asm|
      asm.swpah w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0xa2,0x78] do |asm|
      asm.swpah w2, w3, [sp]
    end
    # SWPALH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0xe0,0x78] do |asm|
      asm.swpalh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0xe2,0x78] do |asm|
      asm.swpalh w2, w3, [sp]
    end
    # SWPH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0x20,0x78] do |asm|
      asm.swph w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0x22,0x78] do |asm|
      asm.swph w2, w3, [sp]
    end
    # SWPLH  <Ws>, <Wt>, [<Xn|SP>]
    assert_bytes [0x41,0x80,0x60,0x78] do |asm|
      asm.swplh w0, w1, [x2]
    end
    assert_bytes [0x41,0x80,0x60,0x78] do |asm|
      asm.swplh w0, w1, [x2]
    end
    assert_bytes [0xe3,0x83,0x62,0x78] do |asm|
      asm.swplh w2, w3, [sp]
    end
  end

  def test_SXTB_SBFM
    # SXTB  <Wd>, <Wn>
    assert_bytes [0x41,0x1c,0x00,0x13] do |asm|
      asm.sxtb     w1, w2
    end
    assert_bytes [0x7f,0x1c,0x40,0x93] do |asm|
      asm.sxtb     xzr, w3
    end
    # SBFM <Wd>, <Wn>, #0, #7
    # SXTB  <Xd>, <Wn>
    # SBFM <Xd>, <Xn>, #0, #7
  end

  def test_SXTH_SBFM
    # SXTH  <Wd>, <Wn>
    assert_bytes [0x20,0x3c,0x40,0x93] do |asm|
      asm.sxth     x0, w1
    end
    # SBFM <Wd>, <Wn>, #0, #15
    # SXTH  <Xd>, <Wn>
    # SBFM <Xd>, <Xn>, #0, #15
  end

  def test_SXTW_SBFM
    # SXTW  <Xd>, <Wn>
    assert_bytes [0xc3,0x7f,0x40,0x93] do |asm|
      asm.sxtw     x3, w30
    end
    # SBFM <Xd>, <Xn>, #0, #31
  end

  def test_SYS
    # SYS  #<op1>, <Cn>, <Cm>, #<op2>{, <Xt>}
    assert_bytes [0xe5,0x59,0x0f,0xd5] do |asm|
      asm.sys     7, c5, c9, 7, x5
    end
    assert_bytes [0x5f,0xff,0x08,0xd5] do |asm|
      asm.sys     0, c15, c15, 2
    end
  end

  def test_SYSL
    # SYSL  <Xt>, #<op1>, <Cn>, <Cm>, #<op2>
    assert_bytes [0xe9,0x59,0x2f,0xd5] do |asm|
      asm.sysl    x9, 7, c5, c9, 7
    end
    assert_bytes [0x41,0xff,0x28,0xd5] do |asm|
      asm.sysl    x1, 0, c15, c15, 2
    end
  end

  def test_TBNZ
    # TBNZ  <R><t>, #<imm>, <label>
    assert_bytes [0x03,0x00,0x44,0x37] do |asm|
      asm.tbnz	w3, 8, -32768
    end
    assert_one_insn "tbnz w3, #5, #4" do |asm|
      label = asm.make_label :foo
      asm.tbnz w3, 5, label
      asm.put_label label
    end
  end

  def test_TBZ
    # TBZ  <R><t>, #<imm>, <label>
    assert_bytes [0xe3,0xff,0x2b,0x36] do |asm|
      asm.tbz	w3, 5, 32764
    end
    assert_one_insn "tbz w3, #5, #4" do |asm|
      label = asm.make_label :foo
      asm.tbz w3, 5, label
      asm.put_label label
    end
  end

  def test_TLBI_SYS
    # TLBI  <tlbi :_op>{, <Xt>}
    assert_bytes [0x1f,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vmalle1is
    end
    assert_bytes [0x1f,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :alle2is
    end
    assert_bytes [0x1f,0x83,0x0e,0xd5] do |asm|
      asm.tlbi :alle3is
    end
    assert_bytes [0x20,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vae1is, x0
    end
    assert_bytes [0x20,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :vae2is, x0
    end
    assert_bytes [0x20,0x83,0x0e,0xd5] do |asm|
      asm.tlbi :vae3is, x0
    end
    assert_bytes [0x40,0x83,0x08,0xd5] do |asm|
      asm.tlbi :aside1is, x0
    end
    assert_bytes [0x60,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vaae1is, x0
    end
    assert_bytes [0x9f,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :alle1is
    end
    assert_bytes [0xa0,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vale1is, x0
    end
    assert_bytes [0xe0,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vaale1is, x0
    end
    assert_bytes [0x1f,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vmalle1
    end
    assert_bytes [0x1f,0x87,0x0c,0xd5] do |asm|
      asm.tlbi :alle2
    end
    assert_bytes [0xa0,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :vale2is, x0
    end
    assert_bytes [0xa0,0x83,0x0e,0xd5] do |asm|
      asm.tlbi :vale3is, x0
    end
    assert_bytes [0x1f,0x87,0x0e,0xd5] do |asm|
      asm.tlbi :alle3
    end
    assert_bytes [0x20,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vae1, x0
    end
    assert_bytes [0x20,0x87,0x0c,0xd5] do |asm|
      asm.tlbi :vae2, x0
    end
    assert_bytes [0x20,0x87,0x0e,0xd5] do |asm|
      asm.tlbi :vae3, x0
    end
    assert_bytes [0x40,0x87,0x08,0xd5] do |asm|
      asm.tlbi :aside1, x0
    end
    assert_bytes [0x60,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vaae1, x0
    end
    assert_bytes [0xa0,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vale1, x0
    end
    assert_bytes [0xa0,0x87,0x0c,0xd5] do |asm|
      asm.tlbi :vale2, x0
    end
    assert_bytes [0xa0,0x87,0x0e,0xd5] do |asm|
      asm.tlbi :vale3, x0
    end
    assert_bytes [0xe0,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vaale1, x0
    end
    assert_bytes [0x20,0x84,0x0c,0xd5] do |asm|
      asm.tlbi :ipas2e1, x0
    end
    assert_bytes [0xa0,0x84,0x0c,0xd5] do |asm|
      asm.tlbi :ipas2le1, x0
    end
    assert_bytes [0x20,0x80,0x0c,0xd5] do |asm|
      asm.tlbi :ipas2e1is, x0
    end
    assert_bytes [0xa0,0x80,0x0c,0xd5] do |asm|
      asm.tlbi :ipas2le1is, x0
    end
    assert_bytes [0xdf,0x87,0x0c,0xd5] do |asm|
      asm.tlbi :vmalls12e1
    end
    assert_bytes [0xdf,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :vmalls12e1is
    end
    assert_bytes [0x24,0x80,0x0c,0xd5] do |asm|
      asm.tlbi :ipas2e1is, x4
    end
    assert_bytes [0xa9,0x80,0x0c,0xd5] do |asm|
      asm.tlbi :ipas2le1is, x9
    end
    assert_bytes [0x1f,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vmalle1is
    end
    assert_bytes [0x1f,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :alle2is
    end
    assert_bytes [0x1f,0x83,0x0e,0xd5] do |asm|
      asm.tlbi :alle3is
    end
    assert_bytes [0x21,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vae1is, x1
    end
    assert_bytes [0x22,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :vae2is, x2
    end
    assert_bytes [0x23,0x83,0x0e,0xd5] do |asm|
      asm.tlbi :vae3is, x3
    end
    assert_bytes [0x45,0x83,0x08,0xd5] do |asm|
      asm.tlbi :aside1is, x5
    end
    assert_bytes [0x69,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vaae1is, x9
    end
    assert_bytes [0x9f,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :alle1is
    end
    assert_bytes [0xaa,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vale1is, x10
    end
    assert_bytes [0xab,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :vale2is, x11
    end
    assert_bytes [0xad,0x83,0x0e,0xd5] do |asm|
      asm.tlbi :vale3is, x13
    end
    assert_bytes [0xdf,0x83,0x0c,0xd5] do |asm|
      asm.tlbi :vmalls12e1is
    end
    assert_bytes [0xee,0x83,0x08,0xd5] do |asm|
      asm.tlbi :vaale1is, x14
    end
    assert_bytes [0x2f,0x84,0x0c,0xd5] do |asm|
      asm.tlbi :ipas2e1, x15
    end
    assert_bytes [0xb0,0x84,0x0c,0xd5] do |asm|
      asm.tlbi :ipas2le1, x16
    end
    assert_bytes [0x1f,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vmalle1
    end
    assert_bytes [0x1f,0x87,0x0c,0xd5] do |asm|
      asm.tlbi :alle2
    end
    assert_bytes [0x1f,0x87,0x0e,0xd5] do |asm|
      asm.tlbi :alle3
    end
    assert_bytes [0x31,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vae1, x17
    end
    assert_bytes [0x32,0x87,0x0c,0xd5] do |asm|
      asm.tlbi :vae2, x18
    end
    assert_bytes [0x33,0x87,0x0e,0xd5] do |asm|
      asm.tlbi :vae3, x19
    end
    assert_bytes [0x54,0x87,0x08,0xd5] do |asm|
      asm.tlbi :aside1, x20
    end
    assert_bytes [0x75,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vaae1, x21
    end
    assert_bytes [0x9f,0x87,0x0c,0xd5] do |asm|
      asm.tlbi :alle1
    end
    assert_bytes [0xb6,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vale1, x22
    end
    assert_bytes [0xb7,0x87,0x0c,0xd5] do |asm|
      asm.tlbi :vale2, x23
    end
    assert_bytes [0xb8,0x87,0x0e,0xd5] do |asm|
      asm.tlbi :vale3, x24
    end
    assert_bytes [0xdf,0x87,0x0c,0xd5] do |asm|
      asm.tlbi :vmalls12e1
    end
    assert_bytes [0xf9,0x87,0x08,0xd5] do |asm|
      asm.tlbi :vaale1, x25
    end
    # SYS #<op1>, C8, <Cm>, #<op2>{, <Xt>}
  end

  def test_TSB
    # TSB CSYNC
    # tsb CSYNC
    assert_bytes [0x5f, 0x22, 0x3, 0xd5] do |asm|
      asm.tsb :csync
    end
  end

  def test_TST_all
    # TST  <Wn>, #<imm>
    assert_bytes [0x3f,0x04,0x00,0x72] do |asm|
      asm.tst	w1, 0x3
    end
    assert_bytes [0x3f,0x04,0x40,0xf2] do |asm|
      asm.tst	x1, 0x3
    end
    assert_bytes [0x3f,0x00,0x02,0x6a] do |asm|
      asm.tst	w1, w2
    end
    assert_bytes [0x3f,0x00,0x02,0xea] do |asm|
      asm.tst	x1, x2
    end
    assert_bytes [0x3f,0x08,0x02,0x6a] do |asm|
      asm.tst	w1, w2, lsl(2)
    end
    assert_bytes [0x3f,0x0c,0x02,0xea] do |asm|
      asm.tst	x1, x2, lsl(3)
    end
    assert_bytes [0x7f,0x7c,0x07,0x6a] do |asm|
      asm.tst	w3, w7, lsl(31)
    end
    assert_bytes [0x5f,0x00,0x94,0xea] do |asm|
      asm.tst	x2, x20, asr(0)
    end
    assert_bytes [0x7f,0x7c,0x07,0x6a] do |asm|
      asm.tst      w3, w7, lsl(31)
    end
    assert_bytes [0x5f,0x00,0x94,0xea] do |asm|
      asm.tst      x2, x20, asr(0)
    end
    # ANDS WZR, <Wn>, #<imm>
    # TST  <Xn>, #<imm>
    # ANDS XZR, <Xn>, #<imm>
  end

  def test_UBFIZ_UBFM
    # UBFIZ  <Wd>, <Wn>, #<lsb>, #<width>
    assert_bytes [0x1f,0x00,0x61,0xd3] do |asm|
      asm.ubfiz xzr, x0, 31, 1
    end
    assert_bytes [0xa4,0x28,0x4c,0xd3] do |asm|
      asm.ubfiz    x4, x5, 52, 11
    end
    assert_bytes [0xe4,0x17,0x7f,0xd3] do |asm|
      asm.ubfiz    x4, xzr, 1, 6
    end
    assert_bytes [0xff,0x2b,0x76,0xd3] do |asm|
      asm.ubfiz    xzr, xzr, 10, 11
    end
    # UBFM <Wd>, <Wn>, #(-<lsb> MOD 32), #(<width>-1)
    # UBFIZ  <Xd>, <Xn>, #<lsb>, #<width>
    # UBFM <Xd>, <Xn>, #(-<lsb> MOD 64), #(<width>-1)
  end

  def test_UBFX_UBFM
    # UBFX  <Wd>, <Wn>, #<lsb>, #<width>
    # UBFM <Wd>, <Wn>, #<lsb>, #(<lsb>+<width>-1)
    # UBFX  <Xd>, <Xn>, #<lsb>, #<width>
    # UBFM <Xd>, <Xn>, #<lsb>, #(<lsb>+<width>-1)
    assert_bytes [0x41,0x3c,0x01,0x53] do |asm|
      asm.ubfx w1, w2, 1, 15
    end
    assert_bytes [0x41,0x3c,0x41,0xd3] do |asm|
      asm.ubfx x1, x2, 1, 15
    end
    assert_bytes [0x9f,0x00,0x40,0xd3] do |asm|
      asm.ubfx     xzr, x4, 0, 1
    end
    assert_bytes [0x49,0x01,0x00,0x53] do |asm|
      asm.ubfx     w9, w10, 0, 1
    end
    assert_bytes [0x49,0x01,0x00,0x53] do |asm|
      asm.ubfx    w9, w10, 0, 1
    end
    assert_bytes [0xff,0x53,0x4a,0xd3] do |asm|
      asm.ubfx    xzr, xzr, 10, 11
    end
  end

  def test_UDF_perm_undef
    # UDF  #<imm>
    # udf 234
    assert_bytes [0xea, 00, 00, 00] do |asm|
      asm.udf 234
    end
    assert_bytes [0x7b, 00, 00, 00] do |asm|
      asm.udf 123
    end
  end

  def test_UDIV
    # UDIV  <Wd>, <Wn>, <Wm>
    # UDIV  <Xd>, <Xn>, <Xm>
    assert_bytes [0x41,0x08,0xc3,0x1a] do |asm|
      asm.udiv w1, w2, w3
    end
    assert_bytes [0x41,0x08,0xc3,0x9a] do |asm|
      asm.udiv x1, x2, x3
    end
    assert_bytes [0xe0,0x08,0xca,0x1a] do |asm|
      asm.udiv	w0, w7, w10
    end
    assert_bytes [0xc9,0x0a,0xc4,0x9a] do |asm|
      asm.udiv	x9, x22, x4
    end
  end

  def test_UMADDL
    # UMADDL  <Xd>, <Wn>, <Wm>, <Xa>
    assert_bytes [0x41,0x10,0xa3,0x9b] do |asm|
      asm.umaddl x1, w2, w3, x4
    end
    assert_bytes [0xa3,0x24,0xa2,0x9b] do |asm|
      asm.umaddl   x3, w5, w2, x9
    end
    assert_bytes [0x5f,0x31,0xab,0x9b] do |asm|
      asm.umaddl   xzr, w10, w11, x12
    end
    assert_bytes [0xed,0x3f,0xae,0x9b] do |asm|
      asm.umaddl   x13, wzr, w14, x15
    end
    assert_bytes [0x30,0x4a,0xbf,0x9b] do |asm|
      asm.umaddl   x16, w17, wzr, x18
    end
  end

  def test_UMNEGL_UMSUBL
    # UMNEGL  <Xd>, <Wn>, <Wm>
    assert_bytes [0x93,0xfe,0xb5,0x9b] do |asm|
      asm.umnegl   x19, w20, w21
    end
    assert_bytes [0xab,0xfd,0xb1,0x9b] do |asm|
      asm.umnegl   x11, w13, w17
    end
    # UMSUBL <Xd>, <Wn>, <Wm>, XZR
  end

  def test_UMSUBL
    # UMSUBL  <Xd>, <Wn>, <Wm>, <Xa>
    assert_bytes [0x41,0x90,0xa3,0x9b] do |asm|
      asm.umsubl x1, w2, w3, x4
    end
    assert_bytes [0xa3,0xa4,0xa2,0x9b] do |asm|
      asm.umsubl   x3, w5, w2, x9
    end
    assert_bytes [0x5f,0xb1,0xab,0x9b] do |asm|
      asm.umsubl   xzr, w10, w11, x12
    end
    assert_bytes [0xed,0xbf,0xae,0x9b] do |asm|
      asm.umsubl   x13, wzr, w14, x15
    end
    assert_bytes [0x30,0xca,0xbf,0x9b] do |asm|
      asm.umsubl   x16, w17, wzr, x18
    end
  end

  def test_UMULH
    # UMULH  <Xd>, <Xn>, <Xm>
    assert_bytes [0x41,0x7c,0xc3,0x9b] do |asm|
      asm.umulh x1, x2, x3
    end
    assert_bytes [0xbe,0x7f,0xdc,0x9b] do |asm|
      asm.umulh    x30, x29, x28
    end
    assert_bytes [0x7f,0x7f,0xda,0x9b] do |asm|
      asm.umulh    xzr, x27, x26
    end
    assert_bytes [0xf9,0x7f,0xd8,0x9b] do |asm|
      asm.umulh    x25, xzr, x24
    end
    assert_bytes [0xd7,0x7e,0xdf,0x9b] do |asm|
      asm.umulh    x23, x22, xzr
    end
  end

  def test_UMULL_UMADDL
    # UMULL  <Xd>, <Wn>, <Wm>
    assert_bytes [0x93,0x7e,0xb5,0x9b] do |asm|
      asm.umull    x19, w20, w21
    end
    assert_bytes [0xab,0x7d,0xb1,0x9b] do |asm|
      asm.umull    x11, w13, w17
    end
    # UMADDL <Xd>, <Wn>, <Wm>, XZR
  end

  def test_UXTB_UBFM
    # UXTB  <Wd>, <Wn>
    assert_bytes [0x41,0x1c,0x00,0x53] do |asm|
      asm.uxtb     w1, w2
    end
    # UBFM <Wd>, <Wn>, #0, #7
  end

  def test_UXTH_UBFM
    # UXTH  <Wd>, <Wn>
    assert_bytes [0x49,0x3d,0x00,0x53] do |asm|
      asm.uxth     w9, w10
    end
    # UBFM <Wd>, <Wn>, #0, #15
  end

  def test_WFE
    # WFE
    assert_bytes [0x5f,0x20,0x03,0xd5] do |asm|
      asm.wfe
    end
  end

  def test_WFET
    # WFET  <Xt>
    # wfet  x3
    assert_bytes [3, 16, 3, 213] do |asm|
      asm.wfet x3
    end
  end

  def test_WFI
    # WFI
    assert_bytes [0x7f,0x20,0x03,0xd5] do |asm|
      asm.wfi
    end
  end

  def test_WFIT
    # WFIT  <Xt>
    # wfit  x3
    assert_bytes [35, 16, 3, 213] do |asm|
      asm.wfit x3
    end
  end

  def test_XAFLAG
    # XAFLAG
    # xaflag
    assert_bytes [0x3f, 0x40, 00, 0xd5] do |asm|
      asm.xaflag
    end
  end

  def test_XPAC
    # XPACD  <Xd>
    # xpacd x3
    assert_bytes [0xe3, 0x47, 0xc1, 0xda] do |asm|
      asm.xpacd x3
    end
    # XPACI  <Xd>
    # xpaci x10
    assert_bytes [0xea, 0x43, 0xc1, 0xda] do |asm|
      asm.xpaci x10
    end
    # XPACLRI
    # xpaclri
    assert_bytes [0xff, 0x20, 0x3, 0xd5] do |asm|
      asm.xpaclri
    end
  end

  def test_YIELD
    # YIELD
    assert_bytes [0x3f,0x20,0x03,0xd5] do |asm|
      asm.yield
    end
  end
end
