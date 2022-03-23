module AArch64
  module Instructions
    # LDADDB, LDADDAB, LDADDALB, LDADDLB -- A64
    # Atomic add on byte in memory
    # LDADDAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDB  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDADDB
      def encode
        raise NotImplementedError
      end

      private

      def LDADDB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_000_00_00000_00000
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
