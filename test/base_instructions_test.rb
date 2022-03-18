require "helper"

class BaseInstructionsTest < AArch64::Test
  include AArch64
  include AArch64::Registers

  attr_reader :asm, :jit_buffer

  def setup
    @asm = Assembler.new
    @jit_buffer = StringIO.new
  end

  def test_brk
    asm.brk 1
    assert_one_insn "brk #0x1"
  end

  def test_ret
    asm.ret
    assert_one_insn "ret"
  end

  def test_movz
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

  def test_movk
    asm.movk X0, 0x2a
    assert_one_insn "movk x0, #0x2a"
  end

  def test_movk_shift
    asm.movk X0, 0x2a, lsl: 16
    assert_one_insn "movk x0, #0x2a, lsl #16"
  end

  def assert_one_insn asm_str
    asm.write_to jit_buffer
    super(jit_buffer.string, asm: asm_str)
  end
end
