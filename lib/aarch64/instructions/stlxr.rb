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

      def encode _
        STLXR(@size, @rs, @rn, @rt)
      end

      private

      def STLXR size, rs, rn, rt
        insn = 0b00_001000_0_0_0_00000_1_11111_00000_00000
        insn |= ((size) << 30)
        insn |= ((rs) << 16)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
