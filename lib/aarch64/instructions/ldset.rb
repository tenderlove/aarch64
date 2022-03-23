module AArch64
  module Instructions
    # LDSET, LDSETA, LDSETAL, LDSETL -- A64
    # Atomic bit set on word or doubleword in memory
    # LDSET  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETA  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETL  <Ws>, <Wt>, [<Xn|SP>]
    # LDSET  <Xs>, <Xt>, [<Xn|SP>]
    # LDSETA  <Xs>, <Xt>, [<Xn|SP>]
    # LDSETAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDSETL  <Xs>, <Xt>, [<Xn|SP>]
    class LDSET
      def encode
        raise NotImplementedError
      end

      private

      def LDSET a, r, rs, rn, rt
        insn = 0b1x_111_0_00_0_0_1_00000_0_011_00_00000_00000
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
