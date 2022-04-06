module AArch64
  module Instructions
    # STXP -- A64
    # Store Exclusive Pair of registers
    # STXP  <Ws>, <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # STXP  <Ws>, <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
    class STXP
      def initialize rs, rt1, rt2, rn
        @rs  = rs
        @rt1 = rt1
        @rt2 = rt2
        @rn  = rn
      end

      def encode
        self.STXP(@rt1.sf, @rs.to_i, @rt2.to_i, @rn.to_i, @rt1.to_i)
      end

      private

      def STXP sz, rs, rt2, rn, rt
        insn = 0b1_0_001000_0_0_1_00000_0_00000_00000_00000
        insn |= ((sz & 0x1) << 30)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rt2 & 0x1f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
