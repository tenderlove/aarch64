require "helper"

class DSLTest < AArch64::Test
  def test_dsl_has_methods
    assert_bytes [0x9f,0x08,0x25,0xab] do |asm|
      asm.pretty do
        asm.cmn      x4, w5, uxtb(2)
      end
    end
  end

  def test_to_binary
    asm = AArch64::Assembler.new
    asm.pretty do
      asm.cmn      x4, w5, uxtb(2)
    end
    assert_equal [0x9f,0x08,0x25,0xab], asm.to_binary.bytes
  end
end
