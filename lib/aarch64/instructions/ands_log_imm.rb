module AArch64
  module Instructions
    # ANDS (immediate) -- A64
    # Bitwise AND (immediate), setting flags
    # ANDS  <Wd>, <Wn>, #<imm>
    # ANDS  <Xd>, <Xn>, #<imm>
    class ANDS_log_imm < Instruction
      def initialize rd, rn, immr, imms, n, sf
        @rd   = check_mask(rd, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @immr = check_mask(immr, 0x3f)
        @imms = check_mask(imms, 0x3f)
        @n    = check_mask(n, 0x01)
        @sf   = check_mask(sf, 0x01)
      end

      def encode
        ANDS_log_imm(@sf, @n, @immr, @imms, @rn, @rd)
      end

      private

      def ANDS_log_imm sf, n, immr, imms, rn, rd
        insn = 0b0_11_100100_0_000000_000000_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(n, 0x1)) << 22)
        insn |= ((apply_mask(immr, 0x3f)) << 16)
        insn |= ((apply_mask(imms, 0x3f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
