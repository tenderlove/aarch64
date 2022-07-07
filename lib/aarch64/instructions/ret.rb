module AArch64
  module Instructions
    # RET -- A64
    # Return from subroutine
    # RET  {<Xn>}
    class RET < Instruction
      def initialize reg
        @reg = reg
      end

      def encode
        RET(@reg.to_i)
      end

      private

      def RET rn
        insn = 0b1101011_0_0_10_11111_0000_0_0_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
