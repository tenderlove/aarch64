module AArch64
  module Instructions
    # ASR (immediate) -- A64
    # Arithmetic Shift Right (immediate)
    # ASR  <Wd>, <Wn>, #<shift>
    # SBFM <Wd>, <Wn>, #<shift>, #31
    # ASR  <Xd>, <Xn>, #<shift>
    # SBFM <Xd>, <Xn>, #<shift>, #63
    class ASR_SBFM
      def initialize d, n, shift
        @d     = d
        @n     = n
        @shift = shift
      end

      def encode
        ASR_SBFM(@d.sf, @d.sf, @shift, @d.sf, @n.to_i, @d.to_i)
      end

      private

      def ASR_SBFM sf, n, immr, imms, rn, rd
        insn = 0b0_00_100110_0_000000_011111_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((immr & 0x3f) << 16)
        insn |= ((imms & 0x1) << 15)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
