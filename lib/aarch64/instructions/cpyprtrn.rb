module AArch64
  module Instructions
    # CPYPRTRN, CPYMRTRN, CPYERTRN -- A64
    # Memory Copy, reads unprivileged and non-temporal
    # CPYERTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMRTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPRTRN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYPRTRN
      def encode
        raise NotImplementedError
      end

      private

      def CPYPRTRN sz, op1, rs, rn, rd
        insn = 0b00_011_1_01_00_0_00000_1010_01_00000_00000
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
