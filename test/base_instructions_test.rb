require "helper"

class BaseInstructionsTest < AArch64::Test
  include AArch64
  include AArch64::Registers
  include AArch64::Conditions
  include AArch64::Extends
  include AArch64::Shifts

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
    assert_bytes [0xe3, 0x7f, 0x00, 0x33] do |asm|
      asm.bfc W3, 0, 32
    end

    # BFC  <Xd>, #<lsb>, #<width>
    assert_bytes [0xe0, 0x23, 0x7b, 0xb3] do |asm|
      asm.bfc X0, 5, 9
    end
  end

  def test_BFI_BFM
    # BFI  <Wd>, <Wn>, #<lsb>, #<width>
    assert_bytes [3, 124, 0, 51] do |asm|
      asm.bfi W3, 0, 32
    end

    # BFI  <Xd>, <Xn>, #<lsb>, #<width>
    assert_bytes [0, 32, 123, 179] do |asm|
      asm.bfi X0, 5, 9
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
    skip "Fixme!"
    # CMN  <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # ADDS WZR, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # CMN  <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    # ADDS XZR, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
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

  def test_CMP_SUBS_addsub_ext
    skip "Fixme!"
    # CMP  <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # SUBS WZR, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # CMP  <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    # SUBS XZR, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
  end

  def test_CMP_SUBS_addsub_imm
    skip "Fixme!"
    # CMP  <Wn|WSP>, #<imm>{, <shift>}
    # SUBS WZR, <Wn|WSP>, #<imm> {, <shift>}
    # CMP  <Xn|SP>, #<imm>{, <shift>}
    # SUBS XZR, <Xn|SP>, #<imm> {, <shift>}
  end

  def test_CMP_SUBS_addsub_shift
    skip "Fixme!"
    # CMP  <Wn>, <Wm>{, <shift> #<amount>}
    # SUBS WZR, <Wn>, <Wm> {, <shift> #<amount>}
    # CMP  <Xn>, <Xm>{, <shift> #<amount>}
    # SUBS XZR, <Xn>, <Xm> {, <shift> #<amount>}
  end

  def test_CMPP_SUBPS
    skip "Fixme!"
    # CMPP  <Xn|SP>, <Xm|SP>
    # SUBPS XZR, <Xn|SP>, <Xm|SP>
  end

  def test_CNEG_CSNEG
    skip "Fixme!"
    # CNEG  <Wd>, <Wn>, <cond>
    # CSNEG <Wd>, <Wn>, <Wn>, invert(<cond>)
    # CNEG  <Xd>, <Xn>, <cond>
    # CSNEG <Xd>, <Xn>, <Xn>, invert(<cond>)
  end

  def test_CPP_SYS
    skip "Fixme!"
    # CPP  RCTX, <Xt>
    # SYS #3, C7, C3, #7, <Xt>
  end

  def test_CPYFP
    skip "Fixme!"
    # CPYFE  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFM  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFP  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPN
    skip "Fixme!"
    # CPYFEN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPRN
    skip "Fixme!"
    # CPYFERN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPRN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPRT
    skip "Fixme!"
    # CPYFERT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMRT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPRT  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPRTN
    skip "Fixme!"
    # CPYFERTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMRTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPRTN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPRTRN
    skip "Fixme!"
    # CPYFERTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMRTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPRTRN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPRTWN
    skip "Fixme!"
    # CPYFERTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMRTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPRTWN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPT
    skip "Fixme!"
    # CPYFET  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPT  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPTN
    skip "Fixme!"
    # CPYFETN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPTN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPTRN
    skip "Fixme!"
    # CPYFETRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPTRN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPTWN
    skip "Fixme!"
    # CPYFETWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPTWN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPWN
    skip "Fixme!"
    # CPYFEWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPWN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPWT
    skip "Fixme!"
    # CPYFEWT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMWT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPWT  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPWTN
    skip "Fixme!"
    # CPYFEWTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMWTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPWTN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPWTRN
    skip "Fixme!"
    # CPYFEWTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMWTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPWTRN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYFPWTWN
    skip "Fixme!"
    # CPYFEWTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMWTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPWTWN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYP
    skip "Fixme!"
    # CPYE  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYM  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYP  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPN
    skip "Fixme!"
    # CPYEN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPRN
    skip "Fixme!"
    # CPYERN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPRN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPRT
    skip "Fixme!"
    # CPYERT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMRT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPRT  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPRTN
    skip "Fixme!"
    # CPYERTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMRTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPRTN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPRTRN
    skip "Fixme!"
    # CPYERTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMRTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPRTRN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPRTWN
    skip "Fixme!"
    # CPYERTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMRTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPRTWN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPT
    skip "Fixme!"
    # CPYET  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPT  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPTN
    skip "Fixme!"
    # CPYETN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPTN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPTRN
    skip "Fixme!"
    # CPYETRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPTRN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPTWN
    skip "Fixme!"
    # CPYETWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPTWN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPWN
    skip "Fixme!"
    # CPYEWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPWN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPWT
    skip "Fixme!"
    # CPYEWT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMWT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPWT  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPWTN
    skip "Fixme!"
    # CPYEWTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMWTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPWTN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPWTRN
    skip "Fixme!"
    # CPYEWTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMWTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPWTRN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CPYPWTWN
    skip "Fixme!"
    # CPYEWTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMWTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPWTWN  [<Xd>]!, [<Xs>]!, <Xn>!
  end

  def test_CRC32
    skip "Fixme!"
    # CRC32B  <Wd>, <Wn>, <Wm>
    # CRC32H  <Wd>, <Wn>, <Wm>
    # CRC32W  <Wd>, <Wn>, <Wm>
    # CRC32X  <Wd>, <Wn>, <Xm>
  end

  def test_CRC32C
    skip "Fixme!"
    # CRC32CB  <Wd>, <Wn>, <Wm>
    # CRC32CH  <Wd>, <Wn>, <Wm>
    # CRC32CW  <Wd>, <Wn>, <Wm>
    # CRC32CX  <Wd>, <Wn>, <Xm>
  end

  def test_CSDB
    skip "Fixme!"
    # CSDB
  end

  def test_CSEL
    skip "Fixme!"
    # CSEL  <Wd>, <Wn>, <Wm>, <cond>
    # CSEL  <Xd>, <Xn>, <Xm>, <cond>
  end

  def test_CSET_CSINC
    skip "Fixme!"
    # CSET  <Wd>, <cond>
    # CSINC <Wd>, WZR, WZR, invert(<cond>)
    # CSET  <Xd>, <cond>
    # CSINC <Xd>, XZR, XZR, invert(<cond>)
  end

  def test_CSETM_CSINV
    skip "Fixme!"
    # CSETM  <Wd>, <cond>
    # CSINV <Wd>, WZR, WZR, invert(<cond>)
    # CSETM  <Xd>, <cond>
    # CSINV <Xd>, XZR, XZR, invert(<cond>)
  end

  def test_CSINC
    skip "Fixme!"
    # CSINC  <Wd>, <Wn>, <Wm>, <cond>
    # CSINC  <Xd>, <Xn>, <Xm>, <cond>
  end

  def test_CSINV
    skip "Fixme!"
    # CSINV  <Wd>, <Wn>, <Wm>, <cond>
    # CSINV  <Xd>, <Xn>, <Xm>, <cond>
  end

  def test_CSNEG
    skip "Fixme!"
    # CSNEG  <Wd>, <Wn>, <Wm>, <cond>
    # CSNEG  <Xd>, <Xn>, <Xm>, <cond>
  end

  def test_DC_SYS
    skip "Fixme!"
    # DC  <dc_op>, <Xt>
    # SYS #<op1>, C7, <Cm>, #<op2>, <Xt>
  end

  def test_DCPS1
    skip "Fixme!"
    # DCPS1  {#<imm>}
  end

  def test_DCPS2
    skip "Fixme!"
    # DCPS2  {#<imm>}
  end

  def test_DCPS3
    skip "Fixme!"
    # DCPS3  {#<imm>}
  end

  def test_DGH
    skip "Fixme!"
    # DGH
  end

  def test_DMB
    skip "Fixme!"
    # DMB  <option>|#<imm>
  end

  def test_DRPS
    skip "Fixme!"
    # DRPS
  end

  def test_DSB
    skip "Fixme!"
    # DSB  <option>|#<imm>
    # DSB  <option>nXS|#<imm>
  end

  def test_DVP_SYS
    skip "Fixme!"
    # DVP  RCTX, <Xt>
    # SYS #3, C7, C3, #5, <Xt>
  end

  def test_EON
    skip "Fixme!"
    # EON  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # EON  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
  end

  def test_EOR_log_imm
    skip "Fixme!"
    # EOR  <Wd|WSP>, <Wn>, #<imm>
    # EOR  <Xd|SP>, <Xn>, #<imm>
  end

  def test_EOR_log_shift
    skip "Fixme!"
    # EOR  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # EOR  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
  end

  def test_ERET
    skip "Fixme!"
    # ERET
  end

  def test_ERETA
    skip "Fixme!"
    # ERETAA
    # ERETAB
  end

  def test_ESB
    skip "Fixme!"
    # ESB
  end

  def test_EXTR
    skip "Fixme!"
    # EXTR  <Wd>, <Wn>, <Wm>, #<lsb>
    # EXTR  <Xd>, <Xn>, <Xm>, #<lsb>
  end

  def test_GMI
    skip "Fixme!"
    # GMI  <Xd>, <Xn|SP>, <Xm>
  end

  def test_HINT
    skip "Fixme!"
    # HINT  #<imm>
  end

  def test_HLT
    skip "Fixme!"
    # HLT  #<imm>
  end

  def test_HVC
    skip "Fixme!"
    # HVC  #<imm>
  end

  def test_IC_SYS
    skip "Fixme!"
    # IC  <ic_op>{, <Xt>}
    # SYS #<op1>, C7, <Cm>, #<op2>{, <Xt>}
  end

  def test_IRG
    skip "Fixme!"
    # IRG  <Xd|SP>, <Xn|SP>{, <Xm>}
  end

  def test_ISB
    skip "Fixme!"
    # ISB  {<option>|#<imm>}
  end

  def test_LD64B
    skip "Fixme!"
    # LD64B  <Xt>, [<Xn|SP> {,#0}]
  end

  def test_LDADD
    skip "Fixme!"
    # LDADD  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDA  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDL  <Ws>, <Wt>, [<Xn|SP>]
    # LDADD  <Xs>, <Xt>, [<Xn|SP>]
    # LDADDA  <Xs>, <Xt>, [<Xn|SP>]
    # LDADDAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDADDL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_LDADDB
    skip "Fixme!"
    # LDADDAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDB  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDLB  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDADDH
    skip "Fixme!"
    # LDADDAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDH  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDLH  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDAPR
    skip "Fixme!"
    # LDAPR  <Wt>, [<Xn|SP> {,#0}]
    # LDAPR  <Xt>, [<Xn|SP> {,#0}]
  end

  def test_LDAPRB
    skip "Fixme!"
    # LDAPRB  <Wt>, [<Xn|SP> {,#0}]
  end

  def test_LDAPRH
    skip "Fixme!"
    # LDAPRH  <Wt>, [<Xn|SP> {,#0}]
  end

  def test_LDAPUR_gen
    skip "Fixme!"
    # LDAPUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPUR  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDAPURB
    skip "Fixme!"
    # LDAPURB  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDAPURH
    skip "Fixme!"
    # LDAPURH  <Wt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDAPURSB
    skip "Fixme!"
    # LDAPURSB  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPURSB  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDAPURSH
    skip "Fixme!"
    # LDAPURSH  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPURSH  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDAPURSW
    skip "Fixme!"
    # LDAPURSW  <Xt>, [<Xn|SP>{, #<simm>}]
  end

  def test_LDAR
    skip "Fixme!"
    # LDAR  <Wt>, [<Xn|SP>{,#0}]
    # LDAR  <Xt>, [<Xn|SP>{,#0}]
  end

  def test_LDARB
    skip "Fixme!"
    # LDARB  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_LDARH
    skip "Fixme!"
    # LDARH  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_LDAXP
    skip "Fixme!"
    # LDAXP  <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # LDAXP  <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
  end

  def test_LDAXR
    skip "Fixme!"
    # LDAXR  <Wt>, [<Xn|SP>{,#0}]
    # LDAXR  <Xt>, [<Xn|SP>{,#0}]
  end

  def test_LDAXRB
    skip "Fixme!"
    # LDAXRB  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_LDAXRH
    skip "Fixme!"
    # LDAXRH  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_LDCLR
    skip "Fixme!"
    # LDCLR  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRA  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRL  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLR  <Xs>, <Xt>, [<Xn|SP>]
    # LDCLRA  <Xs>, <Xt>, [<Xn|SP>]
    # LDCLRAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDCLRL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_LDCLRB
    skip "Fixme!"
    # LDCLRAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRB  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRLB  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDCLRH
    skip "Fixme!"
    # LDCLRAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRH  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRLH  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDEOR
    skip "Fixme!"
    # LDEOR  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORA  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORL  <Ws>, <Wt>, [<Xn|SP>]
    # LDEOR  <Xs>, <Xt>, [<Xn|SP>]
    # LDEORA  <Xs>, <Xt>, [<Xn|SP>]
    # LDEORAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDEORL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_LDEORB
    skip "Fixme!"
    # LDEORAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORB  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORLB  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_LDEORH
    skip "Fixme!"
    # LDEORAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORH  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORLH  <Ws>, <Wt>, [<Xn|SP>]
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
    skip "Fixme!"
    # LDLAR  <Wt>, [<Xn|SP>{,#0}]
    # LDLAR  <Xt>, [<Xn|SP>{,#0}]
  end

  def test_LDLARB
    skip "Fixme!"
    # LDLARB  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_LDLARH
    skip "Fixme!"
    # LDLARH  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_LDNP_gen
    skip "Fixme!"
    # LDNP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # LDNP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
  end

  def test_LDP_gen
    skip "Fixme!"
    # LDP  <Wt1>, <Wt2>, [<Xn|SP>], #<imm>
    # LDP  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # LDP  <Wt1>, <Wt2>, [<Xn|SP>, #<imm>]!
    # LDP  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # LDP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # LDP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
  end

  def test_LDPSW
    skip "Fixme!"
    # LDPSW  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # LDPSW  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # LDPSW  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
  end

  def test_LDR_imm_gen
    skip "Fixme!"
    # LDR  <Wt>, [<Xn|SP>], #<simm>
    # LDR  <Xt>, [<Xn|SP>], #<simm>
    # LDR  <Wt>, [<Xn|SP>, #<simm>]!
    # LDR  <Xt>, [<Xn|SP>, #<simm>]!
    # LDR  <Wt>, [<Xn|SP>{, #<pimm>}]
    # LDR  <Xt>, [<Xn|SP>{, #<pimm>}]
  end

  def test_LDR_lit_gen
    skip "Fixme!"
    # LDR  <Wt>, <label>
    # LDR  <Xt>, <label>
  end

  def test_LDR_reg_gen
    skip "Fixme!"
    # LDR  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    # LDR  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
  end

  def test_LDRA
    skip "Fixme!"
    # LDRAA  <Xt>, [<Xn|SP>{, #<simm>}]
    # LDRAA  <Xt>, [<Xn|SP>{, #<simm>}]!
    # LDRAB  <Xt>, [<Xn|SP>{, #<simm>}]
    # LDRAB  <Xt>, [<Xn|SP>{, #<simm>}]!
  end

  def test_LDRB_imm
    skip "Fixme!"
    # LDRB  <Wt>, [<Xn|SP>], #<simm>
    # LDRB  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRB  <Wt>, [<Xn|SP>{, #<pimm>}]
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
    skip "Fixme!"
    # LDXR  <Wt>, [<Xn|SP>{,#0}]
    # LDXR  <Xt>, [<Xn|SP>{,#0}]
  end

  def test_LDXRB
    skip "Fixme!"
    # LDXRB  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_LDXRH
    skip "Fixme!"
    # LDXRH  <Wt>, [<Xn|SP>{,#0}]
  end

  def test_LSL_UBFM
    skip "Fixme!"
    # LSL  <Wd>, <Wn>, #<shift>
    # UBFM <Wd>, <Wn>, #(-<shift> MOD 32), #(31-<shift>)
    # LSL  <Xd>, <Xn>, #<shift>
    # UBFM <Xd>, <Xn>, #(-<shift> MOD 64), #(63-<shift>)
  end

  def test_LSL_LSLV
    skip "Fixme!"
    # LSL  <Wd>, <Wn>, <Wm>
    # LSLV <Wd>, <Wn>, <Wm>
    # LSL  <Xd>, <Xn>, <Xm>
    # LSLV <Xd>, <Xn>, <Xm>
  end

  def test_LSLV
    skip "Fixme!"
    # LSLV  <Wd>, <Wn>, <Wm>
    # LSLV  <Xd>, <Xn>, <Xm>
  end

  def test_LSR_UBFM
    skip "Fixme!"
    # LSR  <Wd>, <Wn>, #<shift>
    # UBFM <Wd>, <Wn>, #<shift>, #31
    # LSR  <Xd>, <Xn>, #<shift>
    # UBFM <Xd>, <Xn>, #<shift>, #63
  end

  def test_LSR_LSRV
    skip "Fixme!"
    # LSR  <Wd>, <Wn>, <Wm>
    # LSRV <Wd>, <Wn>, <Wm>
    # LSR  <Xd>, <Xn>, <Xm>
    # LSRV <Xd>, <Xn>, <Xm>
  end

  def test_LSRV
    skip "Fixme!"
    # LSRV  <Wd>, <Wn>, <Wm>
    # LSRV  <Xd>, <Xn>, <Xm>
  end

  def test_MADD
    skip "Fixme!"
    # MADD  <Wd>, <Wn>, <Wm>, <Wa>
    # MADD  <Xd>, <Xn>, <Xm>, <Xa>
  end

  def test_MNEG_MSUB
    skip "Fixme!"
    # MNEG  <Wd>, <Wn>, <Wm>
    # MSUB <Wd>, <Wn>, <Wm>, WZR
    # MNEG  <Xd>, <Xn>, <Xm>
    # MSUB <Xd>, <Xn>, <Xm>, XZR
  end

  def test_MOV_ORR_log_imm
    skip "Fixme!"
    # MOV  <Wd|WSP>, #<imm>
    # ORR <Wd|WSP>, WZR, #<imm>
    # MOV  <Xd|SP>, #<imm>
    # ORR <Xd|SP>, XZR, #<imm>
  end

  def test_MOV_MOVN
    skip "Fixme!"
    # MOV  <Wd>, #<imm>
    # MOVN <Wd>, #<imm16>, LSL #<shift>
    # MOV  <Xd>, #<imm>
    # MOVN <Xd>, #<imm16>, LSL #<shift>
  end

  def test_MOV_ORR_log_shift
    skip "Fixme!"
    # MOV  <Wd>, <Wm>
    # ORR <Wd>, WZR, <Wm>
    # MOV  <Xd>, <Xm>
    # ORR <Xd>, XZR, <Xm>
  end

  def test_MOV_ADD_addsub_imm
    skip "Fixme!"
    # MOV  <Wd|WSP>, <Wn|WSP>
    # ADD <Wd|WSP>, <Wn|WSP>, #0
    # MOV  <Xd|SP>, <Xn|SP>
    # ADD <Xd|SP>, <Xn|SP>, #0
  end

  def test_MOV_MOVZ
    skip "Fixme!"
    # MOV  <Wd>, #<imm>
    # MOVZ <Wd>, #<imm16>, LSL #<shift>
    # MOV  <Xd>, #<imm>
    # MOVZ <Xd>, #<imm16>, LSL #<shift>
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
    skip "Fixme!"
    # MOVN  <Wd>, #<imm>{, LSL #<shift>}
    # MOVN  <Xd>, #<imm>{, LSL #<shift>}
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
    skip "Fixme!"
    # MRS  <Xt>, (<systemreg>|S<op0>_<op1>_<Cn>_<Cm>_<op2>)
  end

  def test_MSR_imm
    skip "Fixme!"
    # MSR  <pstatefield>, #<imm>
  end

  def test_MSR_reg
    skip "Fixme!"
    # MSR  (<systemreg>|S<op0>_<op1>_<Cn>_<Cm>_<op2>), <Xt>
  end

  def test_MSUB
    skip "Fixme!"
    # MSUB  <Wd>, <Wn>, <Wm>, <Wa>
    # MSUB  <Xd>, <Xn>, <Xm>, <Xa>
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
    skip "Fixme!"
    # NOP
  end

  def test_ORN_log_shift
    skip "Fixme!"
    # ORN  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # ORN  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
  end

  def test_ORR_log_imm
    skip "Fixme!"
    # ORR  <Wd|WSP>, <Wn>, #<imm>
    # ORR  <Xd|SP>, <Xn>, #<imm>
  end

  def test_ORR_log_shift
    skip "Fixme!"
    # ORR  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # ORR  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
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
    skip "Fixme!"
    # STXP  <Ws>, <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # STXP  <Ws>, <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
  end

  def test_STXR
    skip "Fixme!"
    # STXR  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # STXR  <Ws>, <Xt>, [<Xn|SP>{,#0}]
  end

  def test_STXRB
    skip "Fixme!"
    # STXRB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
  end

  def test_STXRH
    skip "Fixme!"
    # STXRH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
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
    skip "Fixme!"
    # STZGM  <Xt>, [<Xn|SP>]
  end

  def test_SUB_addsub_ext
    skip "Fixme!"
    # SUB  <Wd|WSP>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # SUB  <Xd|SP>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
  end

  def test_SUB_addsub_imm
    skip "Fixme!"
    # SUB  <Wd|WSP>, <Wn|WSP>, #<imm>{, <shift>}
    # SUB  <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
  end

  def test_SUB_addsub_shift
    skip "Fixme!"
    # SUB  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # SUB  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
  end

  def test_SUBG
    skip "Fixme!"
    # SUBG  <Xd|SP>, <Xn|SP>, #<uimm6>, #<uimm4>
  end

  def test_SUBP
    skip "Fixme!"
    # SUBP  <Xd>, <Xn|SP>, <Xm|SP>
  end

  def test_SUBPS
    skip "Fixme!"
    # SUBPS  <Xd>, <Xn|SP>, <Xm|SP>
  end

  def test_SUBS_addsub_ext
    skip "Fixme!"
    # SUBS  <Wd>, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # SUBS  <Xd>, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
  end

  def test_SUBS_addsub_imm
    skip "Fixme!"
    # SUBS  <Wd>, <Wn|WSP>, #<imm>{, <shift>}
    # SUBS  <Xd>, <Xn|SP>, #<imm>{, <shift>}
  end

  def test_SUBS_addsub_shift
    skip "Fixme!"
    # SUBS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # SUBS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
  end

  def test_SVC
    skip "Fixme!"
    # SVC  #<imm>
  end

  def test_SWP
    skip "Fixme!"
    # SWP  <Ws>, <Wt>, [<Xn|SP>]
    # SWPA  <Ws>, <Wt>, [<Xn|SP>]
    # SWPAL  <Ws>, <Wt>, [<Xn|SP>]
    # SWPL  <Ws>, <Wt>, [<Xn|SP>]
    # SWP  <Xs>, <Xt>, [<Xn|SP>]
    # SWPA  <Xs>, <Xt>, [<Xn|SP>]
    # SWPAL  <Xs>, <Xt>, [<Xn|SP>]
    # SWPL  <Xs>, <Xt>, [<Xn|SP>]
  end

  def test_SWPB
    skip "Fixme!"
    # SWPAB  <Ws>, <Wt>, [<Xn|SP>]
    # SWPALB  <Ws>, <Wt>, [<Xn|SP>]
    # SWPB  <Ws>, <Wt>, [<Xn|SP>]
    # SWPLB  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_SWPH
    skip "Fixme!"
    # SWPAH  <Ws>, <Wt>, [<Xn|SP>]
    # SWPALH  <Ws>, <Wt>, [<Xn|SP>]
    # SWPH  <Ws>, <Wt>, [<Xn|SP>]
    # SWPLH  <Ws>, <Wt>, [<Xn|SP>]
  end

  def test_SXTB_SBFM
    skip "Fixme!"
    # SXTB  <Wd>, <Wn>
    # SBFM <Wd>, <Wn>, #0, #7
    # SXTB  <Xd>, <Wn>
    # SBFM <Xd>, <Xn>, #0, #7
  end

  def test_SXTH_SBFM
    skip "Fixme!"
    # SXTH  <Wd>, <Wn>
    # SBFM <Wd>, <Wn>, #0, #15
    # SXTH  <Xd>, <Wn>
    # SBFM <Xd>, <Xn>, #0, #15
  end

  def test_SXTW_SBFM
    skip "Fixme!"
    # SXTW  <Xd>, <Wn>
    # SBFM <Xd>, <Xn>, #0, #31
  end

  def test_SYS
    skip "Fixme!"
    # SYS  #<op1>, <Cn>, <Cm>, #<op2>{, <Xt>}
  end

  def test_SYSL
    skip "Fixme!"
    # SYSL  <Xt>, #<op1>, <Cn>, <Cm>, #<op2>
  end

  def test_TBNZ
    skip "Fixme!"
    # TBNZ  <R><t>, #<imm>, <label>
  end

  def test_TBZ
    skip "Fixme!"
    # TBZ  <R><t>, #<imm>, <label>
  end

  def test_TLBI_SYS
    skip "Fixme!"
    # TLBI  <tlbi_op>{, <Xt>}
    # SYS #<op1>, C8, <Cm>, #<op2>{, <Xt>}
  end

  def test_TSB
    skip "Fixme!"
    # TSB CSYNC
  end

  def test_TST_ANDS_log_imm
    skip "Fixme!"
    # TST  <Wn>, #<imm>
    # ANDS WZR, <Wn>, #<imm>
    # TST  <Xn>, #<imm>
    # ANDS XZR, <Xn>, #<imm>
  end

  def test_TST_ANDS_log_shift
    skip "Fixme!"
    # TST  <Wn>, <Wm>{, <shift> #<amount>}
    # ANDS WZR, <Wn>, <Wm>{, <shift> #<amount>}
    # TST  <Xn>, <Xm>{, <shift> #<amount>}
    # ANDS XZR, <Xn>, <Xm>{, <shift> #<amount>}
  end

  def test_UBFIZ_UBFM
    skip "Fixme!"
    # UBFIZ  <Wd>, <Wn>, #<lsb>, #<width>
    # UBFM <Wd>, <Wn>, #(-<lsb> MOD 32), #(<width>-1)
    # UBFIZ  <Xd>, <Xn>, #<lsb>, #<width>
    # UBFM <Xd>, <Xn>, #(-<lsb> MOD 64), #(<width>-1)
  end

  def test_UBFM
    skip "Fixme!"
    # UBFM  <Wd>, <Wn>, #<immr>, #<imms>
    # UBFM  <Xd>, <Xn>, #<immr>, #<imms>
  end

  def test_UBFX_UBFM
    skip "Fixme!"
    # UBFX  <Wd>, <Wn>, #<lsb>, #<width>
    # UBFM <Wd>, <Wn>, #<lsb>, #(<lsb>+<width>-1)
    # UBFX  <Xd>, <Xn>, #<lsb>, #<width>
    # UBFM <Xd>, <Xn>, #<lsb>, #(<lsb>+<width>-1)
  end

  def test_UDF_perm_undef
    skip "Fixme!"
    # UDF  #<imm>
  end

  def test_UDIV
    skip "Fixme!"
    # UDIV  <Wd>, <Wn>, <Wm>
    # UDIV  <Xd>, <Xn>, <Xm>
  end

  def test_UMADDL
    skip "Fixme!"
    # UMADDL  <Xd>, <Wn>, <Wm>, <Xa>
  end

  def test_UMNEGL_UMSUBL
    skip "Fixme!"
    # UMNEGL  <Xd>, <Wn>, <Wm>
    # UMSUBL <Xd>, <Wn>, <Wm>, XZR
  end

  def test_UMSUBL
    skip "Fixme!"
    # UMSUBL  <Xd>, <Wn>, <Wm>, <Xa>
  end

  def test_UMULH
    skip "Fixme!"
    # UMULH  <Xd>, <Xn>, <Xm>
  end

  def test_UMULL_UMADDL
    skip "Fixme!"
    # UMULL  <Xd>, <Wn>, <Wm>
    # UMADDL <Xd>, <Wn>, <Wm>, XZR
  end

  def test_UXTB_UBFM
    skip "Fixme!"
    # UXTB  <Wd>, <Wn>
    # UBFM <Wd>, <Wn>, #0, #7
  end

  def test_UXTH_UBFM
    skip "Fixme!"
    # UXTH  <Wd>, <Wn>
    # UBFM <Wd>, <Wn>, #0, #15
  end

  def test_WFE
    skip "Fixme!"
    # WFE
  end

  def test_WFET
    skip "Fixme!"
    # WFET  <Xt>
  end

  def test_WFI
    skip "Fixme!"
    # WFI
  end

  def test_WFIT
    skip "Fixme!"
    # WFIT  <Xt>
  end

  def test_XAFLAG
    skip "Fixme!"
    # XAFLAG
  end

  def test_XPAC
    skip "Fixme!"
    # XPACD  <Xd>
    # XPACI  <Xd>
    # XPACLRI
  end

  def test_YIELD
    skip "Fixme!"
    # YIELD
  end

end
