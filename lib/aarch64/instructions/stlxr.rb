module AArch64
  module Instructions
    # STLXR -- A64
    # Store-Release Exclusive Register
    # STLXR  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # STLXR  <Ws>, <Xt>, [<Xn|SP>{,#0}]
    class STLXR < Instruction
      def initialize rs, rt, rn, size
        @rs   = check_mask(rs, 0x1f)
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
      end

      def encode
        STLXR(@size, @rs, @rn, @rt)
      end

      private

      def STLXR size, rs, rn, rt
        insn = 0b00_001000_0_0_0_00000_1_11111_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
