require "helper"

class DSLTest < AArch64::Test
  def test_patch_location
    asm = AArch64::Assembler.new
    found = nil
    asm.pretty do
      asm.mov x0, x1
      asm.patch_location { |loc| found = loc }
      asm.movz x2, 5
    end

    bytes = asm.to_binary
    assert_equal 8, bytes.bytesize
    assert_equal 4, found
  end

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
