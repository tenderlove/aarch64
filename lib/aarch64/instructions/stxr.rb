module AArch64
  module Instructions
    # STXR -- A64
    # Store Exclusive Register
    # STXR  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # STXR  <Ws>, <Xt>, [<Xn|SP>{,#0}]
    class STXR < Instruction
      def initialize rs, rt, rn, size
        @rs   = check_mask(rs, 0x1f)
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
      end

      def encode _
        STXR(@size, @rs, @rn, @rt)
      end

      private

      def STXR size, rs, rn, rt
        insn = 0b00_001000_0_0_0_00000_0_11111_00000_00000
        insn |= ((size) << 30)
        insn |= ((rs) << 16)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
