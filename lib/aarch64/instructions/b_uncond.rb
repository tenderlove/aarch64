module AArch64
  module Instructions
    # B -- A64
    # Branch
    # B  <label>
    class B_uncond < Instruction
      def initialize label
        @label = label
      end

      def encode pos
        B_uncond(check_mask(unwrap_label(@label, pos), 0x3ffffff))
      end

      private

      def B_uncond imm26
        insn = 0b0_00101_00000000000000000000000000
        insn |= imm26
        insn
      end
    end
  end
end
