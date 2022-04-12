module AArch64
  module Instructions
    # SB -- A64
    # Speculation Barrier
    # SB
    class SB
      def encode
        self.SB
      end

      private

      def SB
        insn = 0b1101010100_0_00_011_0011_0000_1_11_11111
        insn
      end
    end
  end
end
