module AArch64
  module Instructions
    # STLXR -- A64
    # Store-Release Exclusive Register
    # STLXR  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # STLXR  <Ws>, <Xt>, [<Xn|SP>{,#0}]
    class STLXR
      def encode
        raise NotImplementedError
      end

      private

      def STLXR rs, rn, rt
        insn = 0b1x_001000_0_0_0_00000_1_11111_00000_00000
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
