module AArch64
  module Instructions
    # NOP -- A64
    # No Operation
    # NOP
    class NOP
      def encode
        0b1101010100_0_00_011_0010_0000_000_11111
      end
    end
  end
end
