module AArch64
  module Instructions
    # LDAXP -- A64
    # Load-Acquire Exclusive Pair of Registers
    # LDAXP  <Wt1>, <Wt2>, [<Xn|SP>{,#0}]
    # LDAXP  <Xt1>, <Xt2>, [<Xn|SP>{,#0}]
    class LDAXP < Instruction
      def initialize rt1, rt2, rn, sf
        @rt1 = rt1
        @rt2 = rt2
        @rn  = rn
        @sf  = sf
      end

      def encode
        LDAXP(@sf, @rt2.to_i, @rn.to_i, @rt1.to_i)
      end

      private

      def LDAXP sz, rt2, rn, rt
        insn = 0b1_0_001000_0_1_1_11111_1_00000_00000_00000
        insn |= ((apply_mask(sz, 0x1)) << 30)
        insn |= ((apply_mask(rt2, 0x1f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
