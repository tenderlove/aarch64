module AArch64
  module Instructions
    # BR -- A64
    # Branch to Register
    # BR  <Xn>
    class BR < Instruction
      def initialize rn
        @rn = rn
      end

      def encode
        BR(@rn.to_i)
      end

      private

      def BR rn
        insn = 0b1101011_0_0_00_11111_0000_0_0_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
