module AArch64
  module Instructions
    # AXFLAG -- A64
    # Convert floating-point condition flags from Arm to external format
    # AXFLAG
    class AXFLAG < Instruction
      def encode _
        0b1101010100_0_00_000_0100_0000_010_11111
      end
    end
  end
end
