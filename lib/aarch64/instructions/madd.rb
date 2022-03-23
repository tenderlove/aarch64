module AArch64
  module Instructions
    # MADD -- A64
    # Multiply-Add
    # MADD  <Wd>, <Wn>, <Wm>, <Wa>
    # MADD  <Xd>, <Xn>, <Xm>, <Xa>
    class MADD
      def encode
        raise NotImplementedError
      end

      private

      def MADD sf, rm, ra, rn, rd
        insn = 0b0_00_11011_000_00000_0_00000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((ra & 0x1f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
