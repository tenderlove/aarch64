module AArch64
  module Instructions
    # SMSUBL -- A64
    # Signed Multiply-Subtract Long
    # SMSUBL  <Xd>, <Wn>, <Wm>, <Xa>
    class SMSUBL < Instruction
      def initialize rd, rn, rm, ra
        @rd = rd
        @rn = rn
        @rm = rm
        @ra = ra
      end

      def encode
        SMSUBL(@rm.to_i, @ra.to_i, @rn.to_i, @rd.to_i)
      end

      private

      def SMSUBL rm, ra, rn, rd
        insn = 0b1_00_11011_0_01_00000_1_00000_00000_00000
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(ra, 0x1f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
