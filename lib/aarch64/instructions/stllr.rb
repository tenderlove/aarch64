module AArch64
  module Instructions
    # STLLR -- A64
    # Store LORelease Register
    # STLLR  <Wt>, [<Xn|SP>{,#0}]
    # STLLR  <Xt>, [<Xn|SP>{,#0}]
    class STLLR
      def encode
        raise NotImplementedError
      end

      private

      def STLLR rn, rt
        insn = 0b1x_001000_1_0_0_11111_0_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
