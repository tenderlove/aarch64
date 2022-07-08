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
    class LDSMIN < Instruction
      def initialize rs, rt, rn, size, a, r
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @size = size
        @a    = a
        @r    = r
      end

      def encode
        LDSMIN(@size, @a, @r.to_i, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDSMIN size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_101_00_00000_00000
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
