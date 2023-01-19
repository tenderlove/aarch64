module AArch64
  module Instructions
    # MADD -- A64
    # Multiply-Add
    # MADD  <Wd>, <Wn>, <Wm>, <Wa>
    # MADD  <Xd>, <Xn>, <Xm>, <Xa>
    class MADD < Instruction
      def initialize rd, rn, rm, ra, sf
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
        @ra = check_mask(ra, 0x1f)
        @sf = check_mask(sf, 0x01)
      end

      def encode _
        MADD(@sf, @rm, @ra, @rn, @rd)
      end

      private

      def MADD sf, rm, ra, rn, rd
        insn = 0b0_00_11011_000_00000_0_00000_00000_00000
        insn |= ((sf) << 31)
        insn |= ((rm) << 16)
        insn |= ((ra) << 10)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
