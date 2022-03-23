module AArch64
  module Instructions
    # SXTW -- A64
    # Sign Extend Word
    # SXTW  <Xd>, <Wn>
    # SBFM <Xd>, <Xn>, #0, #31
    class SXTW_SBFM
      def encode
        raise NotImplementedError
      end

      private

      def SXTW_SBFM rn, rd
        insn = 0b1_00_100110_1_000000_011111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
