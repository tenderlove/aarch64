module AArch64
  module Instructions
    # PSSBB -- A64
    # Physical Speculative Store Bypass Barrier
    # PSSBB
    # DSB #4
    class PSSBB_DSB
      def encode
        raise NotImplementedError
      end

      private

      def PSSBB_DSB 
        insn = 0b1101010100_0_00_011_0011_0100_1_00_11111
        insn
      end
    end
  end
end
