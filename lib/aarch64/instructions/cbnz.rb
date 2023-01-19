module AArch64
  module Instructions
    # CBNZ -- A64
    # Compare and Branch on Nonzero
    # CBNZ  <Wt>, <label>
    # CBNZ  <Xt>, <label>
    class CBNZ < Instruction
      def initialize rt, label, sf
        @rt    = check_mask(rt, 0x1f)
        @label = label
        @sf    = check_mask(sf, 0x1)
      end

      def encode pos
        CBNZ(@sf, check_mask(unwrap_label(@label, pos), 0x7ffff), @rt)
      end

      private

      def CBNZ sf, imm19, rt
        insn = 0b0_011010_1_0000000000000000000_00000
        insn |= (sf << 31)
        insn |= (imm19 << 5)
        insn |= rt
        insn
      end
    end
  end
end
