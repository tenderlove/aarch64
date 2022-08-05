module AArch64
  module Instructions
    # HLT -- A64
    # Halt instruction
    # HLT  #<imm>
    class HLT < Instruction
      def initialize imm
        @imm = check_mask(imm, 0xffff)
      end

      def encode
        HLT(@imm)
      end

      private

      def HLT imm16
        insn = 0b11010100_010_0000000000000000_000_00
        insn |= ((imm16) << 5)
        insn
      end
    end
  end
end
