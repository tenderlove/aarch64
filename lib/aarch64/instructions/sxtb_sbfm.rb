module AArch64
  module Instructions
    # SXTB -- A64
    # Signed Extend Byte
    # SXTB  <Wd>, <Wn>
    # SBFM <Wd>, <Wn>, #0, #7
    # SXTB  <Xd>, <Wn>
    # SBFM <Xd>, <Xn>, #0, #7
    class SXTB_SBFM
      def encode
        raise NotImplementedError
      end

      private

      def SXTB_SBFM sf, n, rn, rd
        insn = 0b0_00_100110_0_000000_000111_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
