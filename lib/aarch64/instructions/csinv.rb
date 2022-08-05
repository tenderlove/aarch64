module AArch64
  module Instructions
    # CSINV -- A64
    # Conditional Select Invert
    # CSINV  <Wd>, <Wn>, <Wm>, <cond>
    # CSINV  <Xd>, <Xn>, <Xm>, <cond>
    class CSINV < Instruction
      def initialize rd, rn, rm, cond, sf
        @rd   = check_mask(rd, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @rm   = check_mask(rm, 0x1f)
        @cond = check_mask(cond, 0x0f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode
        CSINV(@sf, @rm, @cond, @rn, @rd)
      end

      private

      def CSINV sf, rm, cond, rn, rd
        insn = 0b0_1_0_11010100_00000_0000_0_0_00000_00000
        insn |= ((sf) << 31)
        insn |= ((rm) << 16)
        insn |= ((cond) << 12)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
