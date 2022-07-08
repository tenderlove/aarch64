module AArch64
  module Instructions
    # LDAPR -- A64
    # Load-Acquire RCpc Register
    # LDAPR  <Wt>, [<Xn|SP> {,#0}]
    # LDAPR  <Xt>, [<Xn|SP> {,#0}]
    class LDAPR < Instruction
      def initialize rt, rn, size
        @rt   = rt
        @rn   = rn
        @size = size
      end

      def encode
        LDAPR(@size, @rn.to_i, @rt.to_i)
      end

      private

      def LDAPR size, rn, rt
        insn = 0b00_111_0_00_1_0_1_11111_1_100_00_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
