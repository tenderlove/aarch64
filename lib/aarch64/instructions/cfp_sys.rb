module AArch64
  module Instructions
    # CFP -- A64
    # Control Flow Prediction Restriction by Context
    # CFP  RCTX, <Xt>
    # SYS #3, C7, C3, #4, <Xt>
    class CFP_SYS
      def initialize rt
        @rt = rt
      end

      def encode
        CFP_SYS(@rt.to_i)
      end

      private

      def CFP_SYS rt
        insn = 0b1101010100_0_01_011_0111_0011_100_00000
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
