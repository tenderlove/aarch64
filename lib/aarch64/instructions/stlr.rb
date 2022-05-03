module AArch64
  module Instructions
    # STLR -- A64
    # Store-Release Register
    # STLR  <Wt>, [<Xn|SP>{,#0}]
    # STLR  <Xt>, [<Xn|SP>{,#0}]
    class STLR
      def initialize rt, rn, size
        @rt   = rt
        @rn   = rn
        @size = size
      end

      def encode
        STLR(@size, @rn.to_i, @rt.to_i)
      end

      private

      def STLR size, rn, rt
        insn = 0b00_001000_1_0_0_11111_1_11111_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
