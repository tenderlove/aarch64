module AArch64
  module Instructions
    # LDXR -- A64
    # Load Exclusive Register
    # LDXR  <Wt>, [<Xn|SP>{,#0}]
    # LDXR  <Xt>, [<Xn|SP>{,#0}]
    class LDXR
      def encode
        raise NotImplementedError
      end

      private

      def LDXR rn, rt
        insn = 0b1x_001000_0_1_0_11111_0_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
