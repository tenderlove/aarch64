module AArch64
  module Instructions
    # DRPS -- A64
    # Debug restore process state
    # DRPS
    class DRPS < Instruction
      def encode
        DRPS()
      end

      private

      def DRPS
        insn = 0b1101011_0101_11111_000000_11111_00000
        insn
      end
    end
  end
end
