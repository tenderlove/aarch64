module AArch64
  module Instructions
    # STLXRB -- A64
    # Store-Release Exclusive Register Byte
    # STLXRB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class STLXRB
      def initialize rs, rt, rn
        @rs = rs
        @rt = rt
        @rn = rn
      end

      def encode
        STLXRB(@rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def STLXRB rs, rn, rt
        insn = 0b00_001000_0_0_0_00000_1_11111_00000_00000
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
