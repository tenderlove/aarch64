module AArch64
  module Instructions
    # RET -- A64
    # Return from subroutine
    # RET  {<Xn>}
    class RET < Instruction
      def initialize reg
        @reg = check_mask(reg, 0x1f)
      end

      def encode _
        RET(@reg)
      end

      private

      def RET rn
        insn = 0b1101011_0_0_10_11111_0000_0_0_00000_00000
        insn |= ((rn) << 5)
        insn
      end
    end
  end
end
