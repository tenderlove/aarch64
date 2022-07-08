module AArch64
  module Instructions
    # B -- A64
    # Branch
    # B  <label>
    class B_uncond < Instruction
      def initialize label
        @label = label
      end

      def encode
        B_uncond(@label.to_i / 4)
      end

      private

      def B_uncond imm26
        insn = 0b0_00101_00000000000000000000000000
        insn |= (apply_mask(imm26, 0x3ffffff))
        insn
      end
    end
  end
end
