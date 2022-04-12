module AArch64
  module Instructions
    # LDSMIN, LDSMINA, LDSMINAL, LDSMINL -- A64
    # Atomic signed minimum on word or doubleword in memory
    # LDSMIN  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINA  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMIN  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMINA  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMINAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDSMINL  <Xs>, <Xt>, [<Xn|SP>]
    class LDSMIN
      def initialize rs, rt, rn, size, a, r
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @size = size
        @a    = a
        @r    = r
      end

      def encode
        self.LDSMIN(@size, @a, @r.to_i, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDSMIN size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_101_00_00000_00000
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
