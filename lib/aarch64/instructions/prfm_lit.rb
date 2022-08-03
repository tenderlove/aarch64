module AArch64
  module Instructions
    # PRFM (literal) -- A64
    # Prefetch Memory (literal)
    # PRFM  (<prfop>|#<imm5>), <label>
    class PRFM_lit < Instruction
      def initialize rt, label
        @label = label
        @rt    = rt
      end

      def encode
        PRFM_lit(@label, @rt)
      end

      private

      def PRFM_lit label, rt
        insn = 0b11_011_0_00_0000000000000000000_00000
        insn |= ((apply_mask(unwrap_label(label), 0x7ffff)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
