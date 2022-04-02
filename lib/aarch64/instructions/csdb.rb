module AArch64
  module Instructions
    # CSDB -- A64
    # Consumption of Speculative Data Barrier
    # CSDB
    class CSDB
      def encode
        self.CSDB
      end

      private

      def CSDB
        insn = 0b1101010100_0_00_011_0010_0010_100_11111
        insn
      end
    end
  end
end
