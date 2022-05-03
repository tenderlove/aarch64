module AArch64
  module Instructions
    # SEV -- A64
    # Send Event
    # SEV
    class SEV
      def encode
        SEV()
      end

      private

      def SEV
        0b1101010100_0_00_011_0010_0000_100_11111
      end
    end
  end
end
