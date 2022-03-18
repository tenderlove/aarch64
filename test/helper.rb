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

    def assert_one_insn binary, asm:
      insns = disasm(binary)
      assert_equal 1, insns.length
      insn = insns.first
      assert_equal asm, [insn.mnemonic, insn.op_str].reject(&:empty?).join(" ")
    end
  end
end
