module AArch64
  module Instructions
    # CBZ -- A64
    # Compare and Branch on Zero
    # CBZ  <Wt>, <label>
    # CBZ  <Xt>, <label>
    class CBZ < Instruction
      def initialize rt, label, sf
        @rt    = rt
        @label = label
        @sf    = sf
      end

      def encode
        CBZ(@sf, unwrap_label(@label), @rt)
      end

      private

      def CBZ sf, imm19, rt
        insn = 0b0_011010_0_0000000000000000000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(imm19, 0x7ffff)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
