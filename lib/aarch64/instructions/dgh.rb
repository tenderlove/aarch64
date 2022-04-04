module AArch64
  module Instructions
    # DGH -- A64
    # Data Gathering Hint
    # DGH
    class DGH
      def encode
        self.DGH
      end

      private

      def DGH
        insn = 0b1101010100_0_00_011_0010_0000_110_11111
        insn
      end
    end
  end
end
