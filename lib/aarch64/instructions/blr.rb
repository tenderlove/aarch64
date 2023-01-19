module AArch64
  module Instructions
    # BLR -- A64
    # Branch with Link to Register
    # BLR  <Xn>
    class BLR < Instruction
      def initialize n
        @n = check_mask(n, 0x1f)
      end

      def encode _
        BLR(@n)
      end

      private

      def BLR rn
        insn = 0b1101011_0_0_01_11111_0000_0_0_00000_00000
        insn |= ((rn) << 5)
        insn
      end
    end
  end
end
