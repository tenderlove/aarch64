module AArch64
  module Instructions
    # STLXRH -- A64
    # Store-Release Exclusive Register Halfword
    # STLXRH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class STLXRH < Instruction
      def initialize rs, rt, rn
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode _
        STLXRH(@rs, @rn, @rt)
      end

      private

      def STLXRH rs, rn, rt
        insn = 0b01_001000_0_0_0_00000_1_11111_00000_00000
        insn |= ((rs) << 16)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
