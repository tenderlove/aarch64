module AArch64
  module Instructions
    # CPYPTRN, CPYMTRN, CPYETRN -- A64
    # Memory Copy, reads and writes unprivileged, reads non-temporal
    # CPYETRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYPTRN
      def encode
        raise NotImplementedError
      end

      private

      def CPYPTRN sz, op1, rs, rn, rd
        insn = 0b00_011_1_01_00_0_00000_1011_01_00000_00000
        insn |= ((sz & 0x3) << 30)
        insn |= ((op1 & 0x3) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
