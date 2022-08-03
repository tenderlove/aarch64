module AArch64
  module Instructions
    # LDADD, LDADDA, LDADDAL, LDADDL -- A64
    # Atomic add on word or doubleword in memory
    # LDADD  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDA  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDL  <Ws>, <Wt>, [<Xn|SP>]
    # LDADD  <Xs>, <Xt>, [<Xn|SP>]
    # LDADDA  <Xs>, <Xt>, [<Xn|SP>]
    # LDADDAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDADDL  <Xs>, <Xt>, [<Xn|SP>]
    class LDADD < Instruction
      def initialize rs, rt, rn, size, a, r
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @size = size
        @a    = a
        @r    = r
      end

      def encode
        LDADD(@size, @a, @r, @rs, @rn, @rt)
      end

      private

      def LDADD size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_000_00_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(a, 0x1)) << 23)
        insn |= ((apply_mask(r, 0x1)) << 22)
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
