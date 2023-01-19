module AArch64
  module Instructions
    # HVC -- A64
    # Hypervisor Call
    # HVC  #<imm>
    class HVC < Instruction
      def initialize imm
        @imm = check_mask(imm, 0xffff)
      end

      def encode _
        HVC @imm
      end

      private

      def HVC imm16
        insn = 0b11010100_000_0000000000000000_000_10
        insn |= ((imm16) << 5)
        insn
      end
    end
  end
end
