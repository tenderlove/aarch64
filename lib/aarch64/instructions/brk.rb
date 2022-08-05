module AArch64
  module Instructions
    # BRK -- A64
    # Breakpoint instruction
    # BRK  #<imm>
    class BRK < Instruction
      def initialize imm
        @imm = check_mask(imm, 0xffff)
      end

      def encode
        BRK(@imm)
      end

      private

      def BRK imm16
        insn = 0b11010100_001_0000000000000000_000_00
        insn |= ((imm16) << 5)
        insn
      end
    end
  end
end
