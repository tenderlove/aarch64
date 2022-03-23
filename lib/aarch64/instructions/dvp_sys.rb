module AArch64
  module Instructions
    # DVP -- A64
    # Data Value Prediction Restriction by Context
    # DVP  RCTX, <Xt>
    # SYS #3, C7, C3, #5, <Xt>
    class DVP_SYS
      def encode
        raise NotImplementedError
      end

      private

      def DVP_SYS rt
        insn = 0b1101010100_0_01_011_0111_0011_101_00000
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
