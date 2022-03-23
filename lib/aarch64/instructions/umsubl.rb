module AArch64
  module Instructions
    # UMSUBL -- A64
    # Unsigned Multiply-Subtract Long
    # UMSUBL  <Xd>, <Wn>, <Wm>, <Xa>
    class UMSUBL
      def encode
        raise NotImplementedError
      end

      private

      def UMSUBL rm, ra, rn, rd
        insn = 0b1_00_11011_1_01_00000_1_00000_00000_00000
        insn |= ((rm & 0x1f) << 16)
        insn |= ((ra & 0x1f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
