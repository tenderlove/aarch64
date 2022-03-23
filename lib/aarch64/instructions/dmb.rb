module AArch64
  module Instructions
    # DMB -- A64
    # Data Memory Barrier
    # DMB  <option>|#<imm>
    class DMB
      def encode
        raise NotImplementedError
      end

      private

      def DMB crm
        insn = 0b1101010100_0_00_011_0011_0000_1_01_11111
        insn |= ((crm & 0xf) << 8)
        insn
      end
    end
  end
end
