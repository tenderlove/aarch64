module AArch64
  module Instructions
    # LDAPRH -- A64
    # Load-Acquire RCpc Register Halfword
    # LDAPRH  <Wt>, [<Xn|SP> {,#0}]
    class LDAPRH
      def initialize rt, rn
        @rt = rt
        @rn = rn
      end

      def encode
        LDAPRH(@rn.to_i, @rt.to_i)
      end

      private

      def LDAPRH rn, rt
        insn = 0b01_111_0_00_1_0_1_11111_1_100_00_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
