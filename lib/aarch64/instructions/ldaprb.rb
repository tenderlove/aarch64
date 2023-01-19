module AArch64
  module Instructions
    # LDAPRB -- A64
    # Load-Acquire RCpc Register Byte
    # LDAPRB  <Wt>, [<Xn|SP> {,#0}]
    class LDAPRB < Instruction
      def initialize rt, rn
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode _
        LDAPRB(@rn, @rt)
      end

      private

      def LDAPRB rn, rt
        insn = 0b00_111_0_00_1_0_1_11111_1_100_00_00000_00000
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
