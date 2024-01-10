module AArch64
  module Instructions
    # ADRP -- A64
    # Form PC-relative address to 4KB page
    # ADRP  <Xd>, <label>
    class ADRP < Instruction
      def initialize xd, label
        @xd    = check_mask(xd, 0x1f)
        @label = label
      end

      def encode _
        label = unwrap_label(@label, 0) / 4096
        ADRP(label & 0x3, check_mask(label >> 2, 0x7ffff), @xd)
      end

      private

      def ADRP immlo, immhi, rd
        insn = 0b1_00_10000_0000000000000000000_00000
        insn |= (immlo << 29)
        insn |= (immhi << 5)
        insn |= rd
        insn
      end
    end
  end
end
