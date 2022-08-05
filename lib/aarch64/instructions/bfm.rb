module AArch64
  module Instructions
    # BFM -- A64
    # Bitfield Move
    # BFM  <Wd>, <Wn>, #<immr>, #<imms>
    # BFM  <Xd>, <Xn>, #<immr>, #<imms>
    class BFM < Instruction
      def initialize d, n, immr, imms, sf
        @d    = check_mask(d, 0x1f)
        @n    = check_mask(n, 0x1f)
        @immr = check_mask(immr, 0x3f)
        @imms = check_mask(imms, 0x3f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode
        BFM(@sf, @sf, @immr, @imms, @n, @d)
      end

      private

      def BFM sf, n, immr, imms, rn, rd
        insn = 0b0_01_100110_0_000000_000000_00000_00000
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
