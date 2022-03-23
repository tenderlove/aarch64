module AArch64
  module Instructions
    # CPYFPN, CPYFMN, CPYFEN -- A64
    # Memory Copy Forward-only, reads and writes non-temporal
    # CPYFEN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYFPN
      def encode
        raise NotImplementedError
      end

      private

      def CPYFPN sz, op1, rs, rn, rd
        insn = 0b00_011_0_01_00_0_00000_1100_01_00000_00000
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
