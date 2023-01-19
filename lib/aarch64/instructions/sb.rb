module AArch64
  module Instructions
    # SB -- A64
    # Speculation Barrier
    # SB
    class SB < Instruction
      def encode _
        0b1101010100_0_00_011_0011_0000_1_11_11111
      end
    end
  end
end
