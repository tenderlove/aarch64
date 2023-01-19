module AArch64
  module Instructions
    # CFINV -- A64
    # Invert Carry Flag
    # CFINV
    class CFINV < Instruction
      def encode _
        0b1101010100_0_0_0_000_0100_0000_000_11111
      end
    end
  end
end
