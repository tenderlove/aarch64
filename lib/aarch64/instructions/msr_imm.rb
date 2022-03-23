module AArch64
  module Instructions
    # MSR (immediate) -- A64
    # Move immediate value to Special Register
    # MSR  <pstatefield>, #<imm>
    class MSR_imm
      def encode
        raise NotImplementedError
      end

      private

      def MSR_imm op1, crm, op2
        insn = 0b1101010100_0_00_000_0100_0000_000_11111
        insn |= ((op1 & 0x7) << 16)
        insn |= ((crm & 0xf) << 8)
        insn |= ((op2 & 0x7) << 5)
        insn
      end
    end
  end
end
