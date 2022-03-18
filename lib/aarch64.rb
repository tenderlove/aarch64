module AArch64
  module Registers
    class Register < Struct.new(:to_i, :x?)
      def integer?; false; end
    end

    31.times { |i|
      const_set(:"X#{i}", Register.new(i, true))
      const_set(:"W#{i}", Register.new(i, false))
    }
  end

  module Instructions
    class MOVZ
      def initialize reg, imm
        @reg = reg
        @imm = imm
      end

      def encode
        insn = 0b0_10_100101_00_0000000000000000_00000
        insn |= (1 << 31)
        insn |= (@imm << 5)
        insn |= @reg.to_i
      end
    end

    class RET
      def initialize reg
        @reg = reg
      end

      def encode
        insn = 0b1101011_0_0_10_11111_0000_0_0_00000_00000
        insn |= (@reg.to_i << 5)
      end
    end

    class BRK
      def initialize imm
        @imm = imm & 0xFFFF
      end

      def encode
        insn = 0b11010100_001_0000000000000000_000_00
        insn |= (@imm << 5)
      end
    end
  end

  class Assembler
    include Instructions
    include Registers

    def initialize
      @insns = []
    end

    def brk imm
      @insns << BRK.new(imm)
    end

    def ret reg = X30
      @insns << RET.new(reg)
    end

    def movz reg, imm
      @insns << MOVZ.new(reg, imm)
    end

    def write_to io
      io.write @insns.map(&:encode).pack("L<*")
    end
  end
end
