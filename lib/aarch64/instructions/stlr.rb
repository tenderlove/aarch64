module AArch64
  module Instructions
    # STLR -- A64
    # Store-Release Register
    # STLR  <Wt>, [<Xn|SP>{,#0}]
    # STLR  <Xt>, [<Xn|SP>{,#0}]
    class STLR < Instruction
      def initialize rt, rn, size
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
      end

      def encode _
        STLR(@size, @rn, @rt)
      end

      private

      def STLR size, rn, rt
        insn = 0b00_001000_1_0_0_11111_1_11111_00000_00000
        insn |= ((size) << 30)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
