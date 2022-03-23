module AArch64
  module Instructions
    # CPYFPTWN, CPYFMTWN, CPYFETWN -- A64
    # Memory Copy Forward-only, reads and writes unprivileged, writes non-temporal
    # CPYFETWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFMTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    # CPYFPTWN  [<Xd>]!, [<Xs>]!, <Xn>!
    class CPYFPTWN
      def encode
        raise NotImplementedError
      end

      private

      def CPYFPTWN sz, op1, rs, rn, rd
        insn = 0b00_011_0_01_00_0_00000_0111_01_00000_00000
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
