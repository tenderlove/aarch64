module AArch64
  module Instructions
    # SMADDL -- A64
    # Signed Multiply-Add Long
    # SMADDL  <Xd>, <Wn>, <Wm>, <Xa>
    class SMADDL < Instruction
      def initialize rd, rn, rm, ra
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
        @ra = check_mask(ra, 0x1f)
      end

      def encode _
        SMADDL(@rm, @ra, @rn, @rd)
      end

      private

      def SMADDL rm, ra, rn, rd
        insn = 0b1_00_11011_0_01_00000_0_00000_00000_00000
        insn |= ((rm) << 16)
        insn |= ((ra) << 10)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
