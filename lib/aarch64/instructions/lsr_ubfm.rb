module AArch64
  module Instructions
    # LSR (immediate) -- A64
    # Logical Shift Right (immediate)
    # LSR  <Wd>, <Wn>, #<shift>
    # UBFM <Wd>, <Wn>, #<shift>, #31
    # LSR  <Xd>, <Xn>, #<shift>
    # UBFM <Xd>, <Xn>, #<shift>, #63
    class LSR_UBFM
      def encode
        raise NotImplementedError
      end

      private

      def LSR_UBFM sf, n, immr, rn, rd
        insn = 0b0_10_100110_0_000000_x11111_00000_00000
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
