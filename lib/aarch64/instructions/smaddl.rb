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

      def encode
        SMADDL(@rm, @ra, @rn, @rd)
      end

      private

      def SMADDL rm, ra, rn, rd
        insn = 0b1_00_11011_0_01_00000_0_00000_00000_00000
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(ra, 0x1f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
