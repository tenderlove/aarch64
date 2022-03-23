module AArch64
  module Instructions
    # CPYPRTWN, CPYMRTWN, CPYERTWN -- A64
    # Memory Copy, reads unprivileged, writes non-temporal
    # CPYERTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYMRTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYPRTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYPRTWN
      def encode
        raise NotImplementedError
      end

      private

      def CPYPRTWN sz, op1, rs, rn, rd
        insn = 0b00_011_1_01_00_0_00000_0110_01_00000_00000
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
