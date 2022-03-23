module AArch64
  module Instructions
    # LDAXR -- A64
    # Load-Acquire Exclusive Register
    # LDAXR  <Wt>, [<Xn|SP>{,#0}]
    # LDAXR  <Xt>, [<Xn|SP>{,#0}]
    class LDAXR
      def encode
        raise NotImplementedError
      end

      private

      def LDAXR rn, rt
        insn = 0b1x_001000_0_1_0_11111_1_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
