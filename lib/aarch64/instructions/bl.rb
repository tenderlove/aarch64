module AArch64
  module Instructions
    # BL -- A64
    # Branch with Link
    # BL  <label>
    class BL < Instruction
      def initialize label
        @label = label
      end

      def encode
        BL(check_mask(unwrap_label(@label), 0x3ffffff))
      end

      private

      def BL imm26
        insn = 0b1_00101_00000000000000000000000000
        insn |= imm26
        insn
      end
    end
  end
end
