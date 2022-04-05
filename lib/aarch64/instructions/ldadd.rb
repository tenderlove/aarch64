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
    class LDADD
      def initialize rs, rt, rn, size, a, r
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @size = size
        @a    = a
        @r    = r
      end

      def encode
        self.LDADD(@size, @a, @r, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDADD size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_000_00_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((a & 0x1) << 23)
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
