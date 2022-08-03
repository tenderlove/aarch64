module AArch64
  module Instructions
    # LDCLR, LDCLRA, LDCLRAL, LDCLRL -- A64
    # Atomic bit clear on word or doubleword in memory
    # LDCLR  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRA  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRL  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLR  <Xs>, <Xt>, [<Xn|SP>]
    # LDCLRA  <Xs>, <Xt>, [<Xn|SP>]
    # LDCLRAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDCLRL  <Xs>, <Xt>, [<Xn|SP>]
    class LDCLR < Instruction
      def initialize rs, rt, rn, a, r, size
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @a    = a
        @r    = r
        @size = size
      end

      def encode
        LDCLR(@size, @a, @r, @rs, @rn, @rt)
      end

      private

      def LDCLR size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_001_00_00000_00000
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
