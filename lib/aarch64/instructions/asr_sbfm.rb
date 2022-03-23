module AArch64
  module Instructions
    # ASR (immediate) -- A64
    # Arithmetic Shift Right (immediate)
    # ASR  <Wd>, <Wn>, #<shift>
    # SBFM <Wd>, <Wn>, #<shift>, #31
    # ASR  <Xd>, <Xn>, #<shift>
    # SBFM <Xd>, <Xn>, #<shift>, #63
    class ASR_SBFM
      def encode
        raise NotImplementedError
      end

      private

      def ASR_SBFM sf, n, immr, rn, rd
        insn = 0b0_00_100110_0_000000_x11111_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((immr & 0x3f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
