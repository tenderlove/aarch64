module AArch64
  module Instructions
    # UMULH -- A64
    # Unsigned Multiply High
    # UMULH  <Xd>, <Xn>, <Xm>
    class UMULH < Instruction
      def initialize rd, rn, rm
        @rd = rd
        @rn = rn
        @rm = rm
      end

      def encode
        UMULH(@rm.to_i, @rn.to_i, @rd.to_i)
      end

      private

      def UMULH rm, rn, rd
        insn = 0b1_00_11011_1_10_00000_0_11111_00000_00000
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
