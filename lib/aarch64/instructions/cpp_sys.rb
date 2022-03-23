module AArch64
  module Instructions
    # CPP -- A64
    # Cache Prefetch Prediction Restriction by Context
    # CPP  RCTX, <Xt>
    # SYS #3, C7, C3, #7, <Xt>
    class CPP_SYS
      def encode
        raise NotImplementedError
      end

      private

      def CPP_SYS rt
        insn = 0b1101010100_0_01_011_0111_0011_111_00000
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
