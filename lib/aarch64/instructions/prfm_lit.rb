module AArch64
  module Instructions
    # PRFM (literal) -- A64
    # Prefetch Memory (literal)
    # PRFM  (<prfop>|#<imm5>), <label>
    class PRFM_lit < Instruction
      def initialize rt, label
        @label = label
        @rt    = check_mask(rt, 0x1f)
      end

      def encode pos
        PRFM_lit(check_mask(unwrap_label(@label, pos), 0x7ffff), @rt)
      end

      private

      def PRFM_lit label, rt
        insn = 0b11_011_0_00_0000000000000000000_00000
        insn |= (label << 5)
        insn |= rt
        insn
      end
    end
  end
end
