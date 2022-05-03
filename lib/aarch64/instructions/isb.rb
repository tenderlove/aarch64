module AArch64
  module Instructions
    # ISB -- A64
    # Instruction Synchronization Barrier
    # ISB  {<option>|#<imm>}
    class ISB
      def initialize imm
        @imm = imm
      end

      def encode
        ISB @imm
      end

      private

      def ISB crm
        insn = 0b1101010100_0_00_011_0011_0000_1_10_11111
        insn |= ((crm & 0xf) << 8)
        insn
      end
    end
  end
end
