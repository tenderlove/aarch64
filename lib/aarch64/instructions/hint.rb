module AArch64
  module Instructions
    # HINT -- A64
    # Hint instruction
    # HINT  #<imm>
    class HINT < Instruction
      def initialize crm, op2
        @crm = crm
        @op2 = op2
      end

      def encode
        HINT(@crm, @op2)
      end

      private

      def HINT crm, op2
        insn = 0b1101010100_0_00_011_0010_0000_000_11111
        insn |= ((apply_mask(crm, 0xf)) << 8)
        insn |= ((apply_mask(op2, 0x7)) << 5)
        insn
      end
    end
  end
end
