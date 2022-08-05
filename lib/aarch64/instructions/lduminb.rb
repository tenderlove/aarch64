module AArch64
  module Instructions
    # LDUMINB, LDUMINAB, LDUMINALB, LDUMINLB -- A64
    # Atomic unsigned minimum on byte in memory
    # LDUMINAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDUMINB < Instruction
      def initialize rs, rt, rn, a, r
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @a  = check_mask(a, 0x01)
        @r  = check_mask(r, 0x01)
      end

      def encode
        LDUMINB(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDUMINB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_111_00_00000_00000
        insn |= ((a) << 23)
        insn |= ((r) << 22)
        insn |= ((rs) << 16)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
