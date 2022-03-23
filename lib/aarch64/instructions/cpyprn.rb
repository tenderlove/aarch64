module AArch64
  module Instructions
    # CPYPRN, CPYMRN, CPYERN -- A64
    # Memory Copy, reads non-temporal
    # CPYERN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMRN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPRN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYPRN
      def encode
        raise NotImplementedError
      end

      private

      def CPYPRN sz, op1, rs, rn, rd
        insn = 0b00_011_1_01_00_0_00000_1000_01_00000_00000
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
