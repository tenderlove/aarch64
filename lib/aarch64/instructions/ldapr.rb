module AArch64
  module Instructions
    # LDAPR -- A64
    # Load-Acquire RCpc Register
    # LDAPR  <Wt>, [<Xn|SP> {,#0}]
    # LDAPR  <Xt>, [<Xn|SP> {,#0}]
    class LDAPR
      def encode
        raise NotImplementedError
      end

      private

      def LDAPR rn, rt
        insn = 0b1x_111_0_00_1_0_1_11111_1_100_00_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
