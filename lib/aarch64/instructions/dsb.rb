module AArch64
  module Instructions
    # DSB -- A64
    # Data Synchronization Barrier
    # DSB  <option>|#<imm>
    # DSB  <option>nXS|#<imm>
    class DSB < Instruction
      def initialize imm
        @imm = imm
      end

      def encode
        DSB(@imm)
      end

      private

      def DSB crm
        insn = 0b1101010100_0_00_011_0011_0000_1_00_11111
        insn |= ((apply_mask(crm, 0xf)) << 8)
        insn
      end
    end
  end
end
