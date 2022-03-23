module AArch64
  module Instructions
    # UBFIZ -- A64
    # Unsigned Bitfield Insert in Zero
    # UBFIZ  <Wd>, <Wn>, #<lsb>, #<width>
    # UBFM <Wd>, <Wn>, #(-<lsb> MOD 32), #(<width>-1)
    # UBFIZ  <Xd>, <Xn>, #<lsb>, #<width>
    # UBFM <Xd>, <Xn>, #(-<lsb> MOD 64), #(<width>-1)
    class UBFIZ_UBFM
      def encode
        raise NotImplementedError
      end

      private

      def UBFIZ_UBFM sf, n, immr, imms, rn, rd
        insn = 0b0_10_100110_0_000000_000000_00000_00000
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
