module AArch64
  module Instructions
    # CSINC -- A64
    # Conditional Select Increment
    # CSINC  <Wd>, <Wn>, <Wm>, <cond>
    # CSINC  <Xd>, <Xn>, <Xm>, <cond>
    class CSINC < Instruction
      def initialize rd, rn, rm, cond, sf
        @rd   = check_mask(rd, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @rm   = check_mask(rm, 0x1f)
        @cond = check_mask(cond, 0x0f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode
        CSINC(@sf, @rm, @cond, @rn, @rd)
      end

      private

      def CSINC sf, rm, cond, rn, rd
        insn = 0b0_0_0_11010100_00000_0000_0_1_00000_00000
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
