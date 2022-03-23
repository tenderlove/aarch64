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
    class LDCLR
      def encode
        raise NotImplementedError
      end

      private

      def LDCLR a, r, rs, rn, rt
        insn = 0b1x_111_0_00_0_0_1_00000_0_001_00_00000_00000
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
