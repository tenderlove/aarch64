module AArch64
  module Instructions
    # UBFM -- A64
    # Unsigned Bitfield Move
    # UBFM  <Wd>, <Wn>, #<immr>, #<imms>
    # UBFM  <Xd>, <Xn>, #<immr>, #<imms>
    class UBFM < Instruction
      def initialize rd, rn, immr, imms, sf
        @rd   = check_mask(rd, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @immr = check_mask(immr, 0x3f)
        @imms = check_mask(imms, 0x3f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode _
        UBFM(@sf, @sf, @immr, @imms, @rn, @rd)
      end

      private

      def UBFM sf, n, immr, imms, rn, rd
        insn = 0b0_10_100110_0_000000_000000_00000_00000
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
