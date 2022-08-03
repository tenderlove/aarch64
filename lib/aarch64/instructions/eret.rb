module AArch64
  module Instructions
    # ERET -- A64
    # Exception Return
    # ERET
    class ERET < Instruction
      def encode
        0b1101011_0_100_11111_0000_0_0_11111_00000
      end
    end
  end
end
