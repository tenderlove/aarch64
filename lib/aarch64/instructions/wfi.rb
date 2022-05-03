module AArch64
  module Instructions
    # WFI -- A64
    # Wait For Interrupt
    # WFI
    class WFI
      def encode
        0b1101010100_0_00_011_0010_0000_011_11111
      end
    end
  end
end
