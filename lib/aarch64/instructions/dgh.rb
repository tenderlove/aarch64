module AArch64
  module Instructions
    # DGH -- A64
    # Data Gathering Hint
    # DGH
    class DGH < Instruction
      def encode _
        0b1101010100_0_00_011_0010_0000_110_11111
      end
    end
  end
end
