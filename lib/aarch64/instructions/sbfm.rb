module AArch64
  module Instructions
    # SBFM -- A64
    # Signed Bitfield Move
    # SBFM  <Wd>, <Wn>, #<immr>, #<imms>
    # SBFM  <Xd>, <Xn>, #<immr>, #<imms>
    class SBFM < Instruction
      def initialize d, n, immr, imms, sf
        @rd   = d
        @rn   = n
        @immr = immr
        @imms = imms
        @sf   = sf
      end

      def encode
        SBFM(@sf, @sf, @immr, @imms, @rn, @rd)
      end

      private

      def SBFM sf, n, immr, imms, rn, rd
        insn = 0b0_00_100110_0_000000_000000_00000_00000
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
