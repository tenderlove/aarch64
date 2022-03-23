module AArch64
  module Instructions
    # CPYPTN, CPYMTN, CPYETN -- A64
    # Memory Copy, reads and writes unprivileged and non-temporal
    # CPYETN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMTN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPTN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYPTN
      def encode
        raise NotImplementedError
      end

      private

      def CPYPTN sz, op1, rs, rn, rd
        insn = 0b00_011_1_01_00_0_00000_1111_01_00000_00000
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
