module AArch64
  module Instructions
    # HVC -- A64
    # Hypervisor Call
    # HVC  #<imm>
    class HVC < Instruction
      def initialize imm
        @imm = check_mask(imm, 0xffff)
      end

      def encode
        HVC @imm
      end

      private

      def HVC imm16
        insn = 0b11010100_000_0000000000000000_000_10
        insn |= ((apply_mask(imm16, 0xffff)) << 5)
        insn
      end
    end
  end
end
