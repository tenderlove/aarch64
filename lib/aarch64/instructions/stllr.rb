module AArch64
  module Instructions
    # STLLR -- A64
    # Store LORelease Register
    # STLLR  <Wt>, [<Xn|SP>{,#0}]
    # STLLR  <Xt>, [<Xn|SP>{,#0}]
    class STLLR < Instruction
      def initialize rt, rn, size
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
      end

      def encode _
        STLLR(@size, @rn, @rt)
      end

      private

      def STLLR size, rn, rt
        insn = 0b00_001000_1_0_0_11111_0_11111_00000_00000
        insn |= ((size) << 30)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
