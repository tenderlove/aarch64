module AArch64
  module Instructions
    # UXTH -- A64
    # Unsigned Extend Halfword
    # UXTH  <Wd>, <Wn>
    # UBFM <Wd>, <Wn>, #0, #15
    class UXTH_UBFM
      def encode
        raise NotImplementedError
      end

      private

      def UXTH_UBFM rn, rd
        insn = 0b0_10_100110_0_000000_001111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
