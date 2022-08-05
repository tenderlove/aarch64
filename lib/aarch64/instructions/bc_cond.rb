module AArch64
  module Instructions
    # BC.cond -- A64
    # Branch Consistent conditionally
    # BC.<cond>  <label>
    class BC_cond < Instruction
      def initialize cond, label
        @cond  = check_mask(cond, 0xf)
        @label = label
      end

      def encode
        BC_cond(check_mask(unwrap_label(@label), 0x7ffff), @cond)
      end

      private

      def BC_cond imm19, cond
        insn = 0b0101010_0_0000000000000000000_1_0000
        insn |= (imm19 << 5)
        insn |= cond
        insn
      end
    end
  end
end
