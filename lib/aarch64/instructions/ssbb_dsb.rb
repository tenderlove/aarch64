module AArch64
  module Instructions
    # SSBB -- A64
    # Speculative Store Bypass Barrier
    # SSBB
    # DSB #0
    class SSBB_DSB
      def encode
        raise NotImplementedError
      end

      private

      def SSBB_DSB 
        insn = 0b1101010100_0_00_011_0011_0000_1_00_11111
        insn
      end
    end
  end
end
