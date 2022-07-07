module AArch64
  module Instructions
    # BTI -- A64
    # Branch Target Identification
    # BTI  {<targets>}
    class BTI < Instruction
      def initialize target
        @target = target
      end

      def encode
        BTI(@target)
      end

      private

      def BTI target
        insn = 0b1101010100_0_00_011_0010_0100_000_11111
        insn |= ((target & 0x3) << 5)
        insn
      end
    end
  end
end
