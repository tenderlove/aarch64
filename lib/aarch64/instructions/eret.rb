module AArch64
  module Instructions
    # ERET -- A64
    # Exception Return
    # ERET
    class ERET < Instruction
      def encode
        ERET()
      end

      private

      def ERET
        insn = 0b1101011_0_100_11111_0000_0_0_11111_00000
        insn
      end
    end
  end
end
