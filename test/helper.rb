require "aarch64"
require "minitest/autorun"
require "hatstone"
require "stringio"

module AArch64
  class Test < Minitest::Test
    def disasm code
      hs = Hatstone.new(Hatstone::ARCH_ARM64, Hatstone::MODE_ARM)
      hs.disasm(code, 0x0)
    end

    def f str
      str.split(" ").map { |x| x.to_i(16) }
    end

    def assert_bytes bytes
      asm = Assembler.new
      yield asm
      jit_buffer = StringIO.new
      asm.write_to jit_buffer
      if $DEBUG
        actual_bin = sprintf("%032b", jit_buffer.string.unpack1("L<")).gsub(/([01]{4})/, '\1_').sub(/_$/, '')
        expected_bin = sprintf("%032b", bytes.pack("C4").unpack1("L<")).gsub(/([01]{4})/, '\1_').sub(/_$/, '')
        assert_equal expected_bin, actual_bin
      end
      assert_equal bytes, jit_buffer.string.bytes
    end

    def assert_insn binary, asm:
      insns = disasm(binary)
      assert_equal 1, insns.length
      insn = insns.first
      assert_equal asm, [insn.mnemonic, insn.op_str].reject(&:empty?).join(" ")
    end

    def assert_one_insn asm_str
      asm = self.asm

      if block_given?
        asm = Assembler.new
        yield asm
      end

      jit_buffer = StringIO.new
      asm.write_to jit_buffer

      assert_insn(jit_buffer.string, asm: asm_str)
    end
  end
end
