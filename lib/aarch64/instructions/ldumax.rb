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
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @size = size
        @a    = a
        @r    = r
      end

      def encode
        LDUMAX(@size, @a, @r.to_i, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDUMAX size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_110_00_00000_00000
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
