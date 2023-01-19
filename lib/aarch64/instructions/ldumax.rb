module AArch64
  module Instructions
    # LDUMAX, LDUMAXA, LDUMAXAL, LDUMAXL -- A64
    # Atomic unsigned maximum on word or doubleword in memory
    # LDUMAX  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXA  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAX  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMAXA  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMAXAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMAXL  <Xs>, <Xt>, [<Xn|SP>]
    class LDUMAX < Instruction
      def initialize rs, rt, rn, size, a, r
        @rs   = check_mask(rs, 0x1f)
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
        @a    = check_mask(a, 0x01)
        @r    = check_mask(r, 0x01)
      end

      def encode _
        LDUMAX(@size, @a, @r, @rs, @rn, @rt)
      end

      private

      def LDUMAX size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_110_00_00000_00000
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
