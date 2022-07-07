module AArch64
  module Instructions
    # ADRP -- A64
    # Form PC-relative address to 4KB page
    # ADRP  <Xd>, <label>
    class ADRP < Instruction
      def initialize xd, label
        @xd    = xd
        @label = label
      end

      def encode
        label = @label.to_i / 4096
        ADRP(label, label >> 2, @xd.to_i)
      end

      private

      def ADRP immlo, immhi, rd
        insn = 0b1_00_10000_0000000000000000000_00000
        insn |= ((immlo & 0x3) << 29)
        insn |= ((immhi & 0x7ffff) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
