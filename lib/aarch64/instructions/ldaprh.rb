module AArch64
  module Instructions
    # LDAPRH -- A64
    # Load-Acquire RCpc Register Halfword
    # LDAPRH  <Wt>, [<Xn|SP> {,#0}]
    class LDAPRH < Instruction
      def initialize rt, rn
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode
        LDAPRH(@rn, @rt)
      end

      private

      def LDAPRH rn, rt
        insn = 0b01_111_0_00_1_0_1_11111_1_100_00_00000_00000
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
