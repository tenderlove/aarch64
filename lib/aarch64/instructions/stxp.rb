module AArch64
  module Instructions
    # STXP -- A64
    # Store Exclusive Pair of registers
    # STXP  <Ws>, <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # STXP  <Ws>, <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
    class STXP < Instruction
      def initialize rs, rt1, rt2, rn, sf
        @rs  = rs
        @rt1 = rt1
        @rt2 = rt2
        @rn  = rn
        @sf  = sf
      end

      def encode
        STXP(@sf, @rs, @rt2, @rn, @rt1)
      end

      private

      def STXP sz, rs, rt2, rn, rt
        insn = 0b1_0_001000_0_0_1_00000_0_00000_00000_00000
        insn |= ((apply_mask(sz, 0x1)) << 30)
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rt2, 0x1f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
