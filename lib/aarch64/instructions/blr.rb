module AArch64
  module Instructions
    # BLR -- A64
    # Branch with Link to Register
    # BLR  <Xn>
    class BLR < Instruction
      def initialize n
        @n = n
      end

      def encode
        BLR(@n.to_i)
      end

      private

      def BLR rn
        insn = 0b1101011_0_0_01_11111_0000_0_0_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
