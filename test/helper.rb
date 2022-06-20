require "aarch64"
require "aarch64/parser"
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

    def color_diff expected, actual
      len = expected.bytesize
      raise unless actual.bytesize == len

      exp_out = ''
      act_out = ''
      len.times do |i|
        if expected[i] == actual[i]
          exp_out << expected[i]
          act_out << actual[i]
        else
          exp_out << "\e[32m"
          exp_out << expected[i]
          exp_out << "\e[30m"
          act_out << "\e[31m"
          act_out << actual[i]
          act_out << "\e[30m"
        end
      end

      [exp_out, act_out]
    end

    def assert_bytes bytes
      asm = Assembler.new
      x = yield asm
      io = StringIO.new
      asm.write_to io
      assert_equal bytes, io.string.bytes, ->() {
        pos          = 32.times.map { |i| (i % 0x10).to_s(16) }.join.reverse
        actual_bin   = sprintf("%032b", io.string.unpack1("L<"))
        expected_bin = sprintf("%032b", bytes.pack("C4").unpack1("L<"))
        broken = []
        actual_bin.bytes.zip(expected_bin.bytes).each_with_index { |(a, b), i|
          broken << (31 - i) unless a == b
        }
        input = nil
        expected_bin, actual_bin = color_diff(expected_bin, actual_bin)
        "idx: #{pos}\nexp: #{expected_bin}\nact: #{actual_bin}\n" +
          broken.reverse.map { |idx| "Bit #{idx} differs" }.join("\n") +
          "\n#{input}"
      }
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
