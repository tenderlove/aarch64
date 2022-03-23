module AArch64
  module Instructions
    # MUL -- A64
    # Multiply
    # MUL  <Wd>, <Wn>, <Wm>
    # MADD <Wd>, <Wn>, <Wm>, WZR
    # MUL  <Xd>, <Xn>, <Xm>
    # MADD <Xd>, <Xn>, <Xm>, XZR
    class MUL_MADD
      def encode
        raise NotImplementedError
      end

      private

      def MUL_MADD sf, rm, rn, rd
        insn = 0b0_00_11011_000_00000_0_11111_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
