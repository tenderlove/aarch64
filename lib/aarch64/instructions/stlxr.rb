module AArch64
  module Instructions
    # STLXR -- A64
    # Store-Release Exclusive Register
    # STLXR  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # STLXR  <Ws>, <Xt>, [<Xn|SP>{,#0}]
    class STLXR
      def initialize rs, rt, rn, size
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @size = size
      end

      def encode
        self.STLXR(@size, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def STLXR size, rs, rn, rt
        insn = 0b00_001000_0_0_0_00000_1_11111_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
