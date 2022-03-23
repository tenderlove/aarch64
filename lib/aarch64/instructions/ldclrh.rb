module AArch64
  module Instructions
    # LDCLRH, LDCLRAH, LDCLRALH, LDCLRLH -- A64
    # Atomic bit clear on halfword in memory
    # LDCLRAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRH  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDCLRH
      def encode
        raise NotImplementedError
      end

      private

      def LDCLRH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_001_00_00000_00000
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
