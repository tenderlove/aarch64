module AArch64
  module Instructions
    # CPYFPWTN, CPYFMWTN, CPYFEWTN -- A64
    # Memory Copy Forward-only, writes unprivileged, reads and writes non-temporal
    # CPYFEWTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMWTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPWTN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYFPWTN
      def encode
        raise NotImplementedError
      end

      private

      def CPYFPWTN sz, op1, rs, rn, rd
        insn = 0b00_011_0_01_00_0_00000_1101_01_00000_00000
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
