module AArch64
  module Instructions
    # CPYFPTN, CPYFMTN, CPYFETN -- A64
    # Memory Copy Forward-only, reads and writes unprivileged and non-temporal
    # CPYFETN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPTN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYFPTN
      def encode
        raise NotImplementedError
      end

      private

      def CPYFPTN sz, op1, rs, rn, rd
        insn = 0b00_011_0_01_00_0_00000_1111_01_00000_00000
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
