module AArch64
  module Instructions
    # LDSMAX, LDSMAXA, LDSMAXAL, LDSMAXL -- A64
    # Atomic signed maximum on word or doubleword in memory
    # LDSMAX  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXA  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAX  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMAXA  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMAXAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMAXL  <Xs>, <Xt>, [<Xn|SP>]
    class LDSMAX < Instruction
      def initialize rs, rt, rn, size, a, r
        @rs   = check_mask(rs, 0x1f)
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
        @a    = check_mask(a, 0x01)
        @r    = check_mask(r, 0x01)
      end

      def encode
        LDSMAX(@size, @a, @r, @rs, @rn, @rt)
      end

      private

      def LDSMAX size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_100_00_00000_00000
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
