module AArch64
  module Instructions
    # SXTH -- A64
    # Sign Extend Halfword
    # SXTH  <Wd>, <Wn>
    # SBFM <Wd>, <Wn>, #0, #15
    # SXTH  <Xd>, <Wn>
    # SBFM <Xd>, <Xn>, #0, #15
    class SXTH_SBFM
      def encode
        raise NotImplementedError
      end

      private

      def SXTH_SBFM sf, n, rn, rd
        insn = 0b0_00_100110_0_000000_001111_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
