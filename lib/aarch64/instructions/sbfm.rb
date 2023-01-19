module AArch64
  module Instructions
    # SBFM -- A64
    # Signed Bitfield Move
    # SBFM  <Wd>, <Wn>, #<immr>, #<imms>
    # SBFM  <Xd>, <Xn>, #<immr>, #<imms>
    class SBFM < Instruction
      def initialize d, n, immr, imms, sf
        @rd   = check_mask(d, 0x1f)
        @rn   = check_mask(n, 0x1f)
        @immr = check_mask(immr, 0x3f)
        @imms = check_mask(imms, 0x3f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode _
        SBFM(@sf, @sf, @immr, @imms, @rn, @rd)
      end

      private

      def SBFM sf, n, immr, imms, rn, rd
        insn = 0b0_00_100110_0_000000_000000_00000_00000
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
