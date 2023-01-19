module AArch64
  module Instructions
    # AND (immediate) -- A64
    # Bitwise AND (immediate)
    # AND  <Wd|WSP>, <Wn>, #<imm>
    # AND  <Xd|SP>, <Xn>, #<imm>
    class AND_log_imm < Instruction
      def initialize rd, rn, immr, imms, n, sf
        @rd   = check_mask(rd, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @immr = check_mask(immr, 0x3f)
        @imms = check_mask(imms, 0x3f)
        @n    = check_mask(n, 0x01)
        @sf   = check_mask(sf, 0x01)
      end

      def encode _
        AND_log_imm(@sf, @n, @immr, @imms, @rn, @rd)
      end

      private

      def AND_log_imm sf, n, immr, imms, rn, rd
        insn = 0b0_00_100100_0_000000_000000_00000_00000
        insn |= ((sf) << 31)
        insn |= ((n) << 22)
        insn |= ((immr) << 16)
        insn |= ((imms) << 10)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
