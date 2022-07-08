module AArch64
  module Instructions
    # ORR (immediate) -- A64
    # Bitwise OR (immediate)
    # ORR  <Wd|WSP>, <Wn>, #<imm>
    # ORR  <Xd|SP>, <Xn>, #<imm>
    class ORR_log_imm < Instruction
      def initialize rd, rn, n, immr, imms, sf
        @rd   = rd
        @rn   = rn
        @n    = n
        @immr = immr
        @imms = imms
        @sf   = sf
      end

      def encode
        ORR_log_imm(@sf, @n, @immr, @imms, @rn.to_i, @rd.to_i)
      end

      private

      def ORR_log_imm sf, n, immr, imms, rn, rd
        insn = 0b0_01_100100_0_000000_000000_00000_00000
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
