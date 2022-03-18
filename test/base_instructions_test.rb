require "helper"

class BaseInstructionsTest < AArch64::Test
  include AArch64
  include AArch64::Registers

  def test_brk
    jit_buffer = StringIO.new

    asm = Assembler.new
    asm.brk 1

    asm.write_to jit_buffer
    insns = disasm(jit_buffer.string)
    assert_equal 1, insns.length
    assert_equal "brk", insns.first.mnemonic
  end

  def test_ret
    jit_buffer = StringIO.new

    asm = Assembler.new
    asm.ret

    asm.write_to jit_buffer
    insns = disasm(jit_buffer.string)
    assert_equal 1, insns.length
    assert_equal "ret", insns.first.mnemonic
    assert_equal "", insns.first.op_str
  end

  def test_movz
    jit_buffer = StringIO.new

    asm = Assembler.new
    asm.movz X0, 0x2a

    asm.write_to jit_buffer
    insns = disasm(jit_buffer.string)
    assert_equal 1, insns.length
    assert_equal "movz", insns.first.mnemonic
    assert_equal "x0, #0x2a", insns.first.op_str
  end
end
