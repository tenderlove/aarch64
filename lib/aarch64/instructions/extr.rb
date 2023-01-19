module AArch64
  module Instructions
    # EXTR -- A64
    # Extract register
    # EXTR  <Wd>, <Wn>, <Wm>, #<lsb>
    # EXTR  <Xd>, <Xn>, <Xm>, #<lsb>
    class EXTR < Instruction
      def initialize rd, rn, rm, lsb, sf
        @rd  = check_mask(rd, 0x1f)
        @rn  = check_mask(rn, 0x1f)
        @rm  = check_mask(rm, 0x1f)
        @lsb = check_mask(lsb, 0x3f)
        @sf  = check_mask(sf, 0x01)
      end

      def encode _
        EXTR(@sf, @sf, @rm, @lsb, @rn, @rd)
      end

      private

      def EXTR sf, n, rm, imms, rn, rd
        insn = 0b0_00_100111_0_0_00000_000000_00000_00000
        insn |= ((sf) << 31)
        insn |= ((n) << 22)
        insn |= ((rm) << 16)
        insn |= ((imms) << 10)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
