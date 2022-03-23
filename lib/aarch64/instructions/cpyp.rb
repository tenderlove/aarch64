module AArch64
  module Instructions
    # CPYP, CPYM, CPYE -- A64
    # Memory Copy
    # CPYE  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYM  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYP  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYP
      def encode
        raise NotImplementedError
      end

      private

      def CPYP sz, op1, rs, rn, rd
        insn = 0b00_011_1_01_00_0_00000_0000_01_00000_00000
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
