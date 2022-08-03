module AArch64
  module Instructions
    # STLXRB -- A64
    # Store-Release Exclusive Register Byte
    # STLXRB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class STLXRB < Instruction
      def initialize rs, rt, rn
        @rs = rs
        @rt = rt
        @rn = rn
      end

      def encode
        STLXRB(@rs, @rn, @rt)
      end

      private

      def STLXRB rs, rn, rt
        insn = 0b00_001000_0_0_0_00000_1_11111_00000_00000
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
