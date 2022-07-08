module AArch64
  module Instructions
    # LDXP -- A64
    # Load Exclusive Pair of Registers
    # LDXP  <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # LDXP  <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
    class LDXP < Instruction
      def initialize rt, rt2, rn, sz
        @rt  = rt
        @rt2 = rt2
        @rn  = rn
        @sz  = sz
      end

      def encode
        LDXP(@sz, @rt2.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDXP sz, rt2, rn, rt
        insn = 0b1_0_001000_0_1_1_11111_0_00000_00000_00000
        insn |= ((apply_mask(sz, 0x1)) << 30)
        insn |= ((apply_mask(rt2, 0x1f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
