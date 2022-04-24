module AArch64
  module Instructions
    # SEVL -- A64
    # Send Event Local
    # SEVL
    class SEVL
      def encode
        self.SEVL
      end

      private

      def SEVL
        0b1101010100_0_00_011_0010_0000_101_11111
      end
    end
  end
end
