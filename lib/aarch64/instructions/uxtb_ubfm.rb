module AArch64
  module Instructions
    # UXTB -- A64
    # Unsigned Extend Byte
    # UXTB  <Wd>, <Wn>
    # UBFM <Wd>, <Wn>, #0, #7
    class UXTB_UBFM
      def encode
        raise NotImplementedError
      end

      private

      def UXTB_UBFM rn, rd
        insn = 0b0_10_100110_0_000000_000111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
