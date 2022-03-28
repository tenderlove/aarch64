module AArch64
  module Instructions
    # BFXIL -- A64
    # Bitfield extract and insert at low end
    # BFXIL  <Wd>, <Wn>, #<lsb>, #<width>
    # BFXIL  <Xd>, <Xn>, #<lsb>, #<width>
    class BFXIL_BFM
      def initialize d, n, lsb, width
        @d     = d
        @n     = n
        @lsb   = lsb
        @width = width
      end

      def encode
        BFXIL_BFM(@d.sf, @d.sf, @lsb, @lsb + @width - 1, @n.to_i, @d.to_i)
      end

      private

      def BFXIL_BFM sf, n, immr, imms, rn, rd
        insn = 0b0_01_100110_0_000000_000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((immr & 0x3f) << 16)
        insn |= ((imms & 0x3f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
