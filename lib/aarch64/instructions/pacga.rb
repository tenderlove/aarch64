module AArch64
  module Instructions
    # PACGA -- A64
    # Pointer Authentication Code, using Generic key
    # PACGA  <Xd>, <Xn>, <Xm|SP>
    class PACGA < Instruction
      def initialize rd, rn, rm
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
      end

      def encode _
        PACGA(@rm, @rn, @rd)
      end

      private

      def PACGA rm, rn, rd
        insn = 0b1_0_0_11010110_00000_001100_00000_00000
        insn |= ((rm) << 16)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
