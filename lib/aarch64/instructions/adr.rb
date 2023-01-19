module AArch64
  module Instructions
    # ADR -- A64
    # Form PC-relative address
    # ADR  <Xd>, <label>
    class ADR < Instruction
      def initialize xd, label
        @xd    = check_mask(xd, 0x1f)
        @label = label
      end

      def encode
        label = unwrap_label(@label) * 4
        ADR(label & 0x3, check_mask((label >> 2), 0x7ffff), @xd)
      end

      private

      def ADR immlo, immhi, rd
        insn = 0b0_00_10000_0000000000000000000_00000
        insn |= (immlo << 29)
        insn |= (immhi << 5)
        insn |= rd
        insn
      end
    end
  end
end
