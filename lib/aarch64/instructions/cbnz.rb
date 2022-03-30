module AArch64
  module Instructions
    # CBNZ -- A64
    # Compare and Branch on Nonzero
    # CBNZ  <Wt>, <label>
    # CBNZ  <Xt>, <label>
    class CBNZ
      def initialize rt, label
        @rt    = rt
        @label = label
      end

      def encode
        CBNZ(@rt.sf, @label.to_i / 4, @rt.to_i)
      end

      private

      def CBNZ sf, imm19, rt
        insn = 0b0_011010_1_0000000000000000000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((imm19 & 0x7ffff) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
