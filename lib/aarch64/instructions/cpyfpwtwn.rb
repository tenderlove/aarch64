module AArch64
  module Instructions
    # CPYFPWTWN, CPYFMWTWN, CPYFEWTWN -- A64
    # Memory Copy Forward-only, writes unprivileged and non-temporal
    # CPYFEWTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMWTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPWTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYFPWTWN
      def encode
        raise NotImplementedError
      end

      private

      def CPYFPWTWN sz, op1, rs, rn, rd
        insn = 0b00_011_0_01_00_0_00000_0101_01_00000_00000
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
