module AArch64
  module Instructions
    # ADR -- A64
    # Form PC-relative address
    # ADR  <Xd>, <label>
    class ADR < Instruction
      def initialize xd, label
        @xd    = xd
        @label = label
      end

      def encode
        label = @label.to_i
        ADR(label & 0x3, label >> 2, @xd.to_i)
      end

      private

      def ADR immlo, immhi, rd
        insn = 0b0_00_10000_0000000000000000000_00000
        insn |= ((apply_mask(immlo, 0x3)) << 29)
        insn |= ((apply_mask(immhi, 0x7ffff)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
