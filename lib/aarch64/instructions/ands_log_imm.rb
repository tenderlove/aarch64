module AArch64
  module Instructions
    # ANDS (immediate) -- A64
    # Bitwise AND (immediate), setting flags
    # ANDS  <Wd>, <Wn>, #<imm>
    # ANDS  <Xd>, <Xn>, #<imm>
    class ANDS_log_imm
      def initialize rd, rn, immr, imms, n, sf
        @rd   = rd
        @rn   = rn
        @immr = immr
        @imms = imms
        @n    = n
        @sf   = sf
      end

      def encode
        ANDS_log_imm(@sf, @n, @immr, @imms, @rn.to_i, @rd.to_i)
      end

      private

      def ANDS_log_imm sf, n, immr, imms, rn, rd
        insn = 0b0_11_100100_0_000000_000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((immr & 0x3f) << 16)
        insn |= ((imms & 0x3f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
