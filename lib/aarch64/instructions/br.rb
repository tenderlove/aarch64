module AArch64
  module Instructions
    # BR -- A64
    # Branch to Register
    # BR  <Xn>
    class BR < Instruction
      def initialize rn
        @rn = check_mask(rn, 0x1f)
      end

      def encode
        BR(@rn)
      end

      private

      def BR rn
        insn = 0b1101011_0_0_00_11111_0000_0_0_00000_00000
        insn |= ((rn) << 5)
        insn
      end
    end
  end
end
