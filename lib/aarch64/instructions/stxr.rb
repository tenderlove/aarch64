module AArch64
  module Instructions
    # STXR -- A64
    # Store Exclusive Register
    # STXR  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # STXR  <Ws>, <Xt>, [<Xn|SP>{,#0}]
    class STXR
      def encode
        raise NotImplementedError
      end

      private

      def STXR rs, rn, rt
        insn = 0b1x_001000_0_0_0_00000_0_11111_00000_00000
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
