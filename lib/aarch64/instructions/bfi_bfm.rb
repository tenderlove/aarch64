module AArch64
  module Instructions
    # BFI -- A64
    # Bitfield Insert
    # BFI  <Wd>, <Wn>, #<lsb>, #<width>
    # BFM  <Wd>, <Wn>, #(-<lsb> MOD 32), #(<width>-1)
    # BFI  <Xd>, <Xn>, #<lsb>, #<width>
    # BFM  <Xd>, <Xn>, #(-<lsb> MOD 64), #(<width>-1)
    class BFI_BFM
      def encode
        raise NotImplementedError
      end

      private

      def BFI_BFM sf, n, immr, imms, rd
        insn = 0b0_01_100110_0_000000_000000_!= 11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((immr & 0x3f) << 16)
        insn |= ((imms & 0x3f) << 10)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
