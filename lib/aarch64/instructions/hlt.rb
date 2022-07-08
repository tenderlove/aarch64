module AArch64
  module Instructions
    # HLT -- A64
    # Halt instruction
    # HLT  #<imm>
    class HLT < Instruction
      def initialize imm
        @imm = imm
      end

      def encode
        HLT(@imm)
      end

      private

      def HLT imm16
        insn = 0b11010100_010_0000000000000000_000_00
        insn |= ((apply_mask(imm16, 0xffff)) << 5)
        insn
      end
    end
  end
end
