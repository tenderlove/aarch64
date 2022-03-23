module AArch64
  module Instructions
    # CPYPWT, CPYMWT, CPYEWT -- A64
    # Memory Copy, writes unprivileged
    # CPYEWT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMWT  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPWT  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYPWT
      def encode
        raise NotImplementedError
      end

      private

      def CPYPWT sz, op1, rs, rn, rd
        insn = 0b00_011_1_01_00_0_00000_0001_01_00000_00000
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
