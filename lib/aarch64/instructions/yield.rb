module AArch64
  module Instructions
    # YIELD -- A64
    # YIELD
    # YIELD
    class YIELD < Instruction
      def encode
        0b1101010100_0_00_011_0010_0000_001_11111
      end
    end
  end
end
