module AArch64
  module Instructions
    # MNEG -- A64
    # Multiply-Negate
    # MNEG  <Wd>, <Wn>, <Wm>
    # MSUB <Wd>, <Wn>, <Wm>, WZR
    # MNEG  <Xd>, <Xn>, <Xm>
    # MSUB <Xd>, <Xn>, <Xm>, XZR
    class MNEG_MSUB
      def encode
        raise NotImplementedError
      end

      private

      def MNEG_MSUB sf, rm, rn, rd
        insn = 0b0_00_11011_000_00000_1_11111_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
