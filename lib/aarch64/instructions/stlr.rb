module AArch64
  module Instructions
    # STLR -- A64
    # Store-Release Register
    # STLR  <Wt>, [<Xn|SP>{,#0}]
    # STLR  <Xt>, [<Xn|SP>{,#0}]
    class STLR
      def encode
        raise NotImplementedError
      end

      private

      def STLR rn, rt
        insn = 0b1x_001000_1_0_0_11111_1_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
