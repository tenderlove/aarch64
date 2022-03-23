module AArch64
  module Instructions
    # LDCLRB, LDCLRAB, LDCLRALB, LDCLRLB -- A64
    # Atomic bit clear on byte in memory
    # LDCLRAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRB  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDCLRB
      def encode
        raise NotImplementedError
      end

      private

      def LDCLRB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_001_00_00000_00000
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
