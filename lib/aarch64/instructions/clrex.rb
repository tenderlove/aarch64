module AArch64
  module Instructions
    # CLREX -- A64
    # Clear Exclusive
    # CLREX  {#<imm>}
    class CLREX < Instruction
      def initialize imm
        @imm = check_mask(imm, 0x0f)
      end

      def encode
        CLREX(@imm)
      end

      private

      def CLREX crm
        insn = 0b1101010100_0_00_011_0011_0000_010_11111
        insn |= ((apply_mask(crm, 0xf)) << 8)
        insn
      end
    end
  end
end
