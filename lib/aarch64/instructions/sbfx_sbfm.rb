module AArch64
  module Instructions
    # SBFX -- A64
    # Signed Bitfield Extract
    # SBFX  <Wd>, <Wn>, #<lsb>, #<width>
    # SBFM <Wd>, <Wn>, #<lsb>, #(<lsb>+<width>-1)
    # SBFX  <Xd>, <Xn>, #<lsb>, #<width>
    # SBFM <Xd>, <Xn>, #<lsb>, #(<lsb>+<width>-1)
    class SBFX_SBFM
      def encode
        raise NotImplementedError
      end

      private

      def SBFX_SBFM sf, n, immr, imms, rn, rd
        insn = 0b0_00_100110_0_000000_000000_00000_00000
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
