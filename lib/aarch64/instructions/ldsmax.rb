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
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @size = size
        @a    = a
        @r    = r
      end

      def encode
        LDSMAX(@size, @a, @r.to_i, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDSMAX size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_100_00_00000_00000
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
