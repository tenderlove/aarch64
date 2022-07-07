module AArch64
  module Instructions
    # XAFLAG -- A64
    # Convert floating-point condition flags from external format to Arm format
    # XAFLAG
    class XAFLAG < Instruction
      def encode
        0b1101010100_0_00_000_0100_0000_001_11111
      end
    end
  end
end
