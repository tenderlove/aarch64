module AArch64
  module Instructions
    # STXR -- A64
    # Store Exclusive Register
    # STXR  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # STXR  <Ws>, <Xt>, [<Xn|SP>{,#0}]
    class STXR < Instruction
      def initialize rs, rt, rn, size
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @size = size
      end

      def encode
        STXR(@size, @rs, @rn, @rt)
      end

      private

      def STXR size, rs, rn, rt
        insn = 0b00_001000_0_0_0_00000_0_11111_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
