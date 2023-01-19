module AArch64
  module Instructions
    # UMULH -- A64
    # Unsigned Multiply High
    # UMULH  <Xd>, <Xn>, <Xm>
    class UMULH < Instruction
      def initialize rd, rn, rm
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
      end

      def encode _
        UMULH(@rm, @rn, @rd)
      end

      private

      def UMULH rm, rn, rd
        insn = 0b1_00_11011_1_10_00000_0_11111_00000_00000
        insn |= ((rm) << 16)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
