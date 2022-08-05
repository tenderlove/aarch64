module AArch64
  module Instructions
    # EOR (immediate) -- A64
    # Bitwise Exclusive OR (immediate)
    # EOR  <Wd|WSP>, <Wn>, #<imm>
    # EOR  <Xd|SP>, <Xn>, #<imm>
    class EOR_log_imm < Instruction
      def initialize rd, rn, n, immr, imms, sf
        @rd   = check_mask(rd, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @n    = check_mask(n, 0x01)
        @immr = check_mask(immr, 0x3f)
        @imms = check_mask(imms, 0x3f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode
        EOR_log_imm(@sf, @n, @immr, @imms, @rn, @rd)
      end

      private

      def EOR_log_imm sf, n, immr, imms, rn, rd
        insn = 0b0_10_100100_0_000000_000000_00000_00000
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
