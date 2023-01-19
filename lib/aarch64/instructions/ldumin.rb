module AArch64
  module Instructions
    # LDUMIN, LDUMINA, LDUMINAL, LDUMINL -- A64
    # Atomic unsigned minimum on word or doubleword in memory
    # LDUMIN  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINA  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMIN  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMINA  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMINAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMINL  <Xs>, <Xt>, [<Xn|SP>]
    class LDUMIN < Instruction
      def initialize rs, rt, rn, size, a, r
        @rs   = check_mask(rs, 0x1f)
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
        @a    = check_mask(a, 0x01)
        @r    = check_mask(r, 0x01)
      end

      def encode _
        LDUMIN(@size, @a, @r, @rs, @rn, @rt)
      end

      private

      def LDUMIN size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_111_00_00000_00000
        insn |= ((size) << 30)
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
