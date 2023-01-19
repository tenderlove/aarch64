module AArch64
  module Instructions
    # STXP -- A64
    # Store Exclusive Pair of registers
    # STXP  <Ws>, <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # STXP  <Ws>, <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
    class STXP < Instruction
      def initialize rs, rt1, rt2, rn, sf
        @rs  = check_mask(rs, 0x1f)
        @rt1 = check_mask(rt1, 0x1f)
        @rt2 = check_mask(rt2, 0x1f)
        @rn  = check_mask(rn, 0x1f)
        @sf  = check_mask(sf, 0x01)
      end

      def encode _
        STXP(@sf, @rs, @rt2, @rn, @rt1)
      end

      private

      def STXP sz, rs, rt2, rn, rt
        insn = 0b1_0_001000_0_0_1_00000_0_00000_00000_00000
        insn |= ((sz) << 30)
        insn |= ((rs) << 16)
        insn |= ((rt2) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
