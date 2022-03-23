module AArch64
  module Instructions
    # CPYFPTRN, CPYFMTRN, CPYFETRN -- A64
    # Memory Copy Forward-only, reads and writes unprivileged, reads non-temporal
    # CPYFETRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYFPTRN
      def encode
        raise NotImplementedError
      end

      private

      def CPYFPTRN sz, op1, rs, rn, rd
        insn = 0b00_011_0_01_00_0_00000_1011_01_00000_00000
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
