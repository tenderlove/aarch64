module AArch64
  module Instructions
    # CPYPN, CPYMN, CPYEN -- A64
    # Memory Copy, reads and writes non-temporal
    # CPYEN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYPN
      def encode
        raise NotImplementedError
      end

      private

      def CPYPN sz, op1, rs, rn, rd
        insn = 0b00_011_1_01_00_0_00000_1100_01_00000_00000
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
