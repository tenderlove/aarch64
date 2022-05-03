module AArch64
  module Instructions
    # YIELD -- A64
    # YIELD
    # YIELD
    class YIELD
      def encode
        YIELD()
      end

      private

      def YIELD
        insn = 0b1101010100_0_00_011_0010_0000_001_11111
        insn
      end
    end
  end
end
