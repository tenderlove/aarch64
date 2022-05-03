module AArch64
  module Instructions
    # XPACLRI -- A64
    # Strip Pointer Authentication Code
    # XPACLRI
    class XPACLRI
      def encode
        0b11010101000000110010000011111111
      end
    end
  end
end
