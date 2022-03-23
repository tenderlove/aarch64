module AArch64
  module Instructions
    # SETGPTN, SETGMTN, SETGETN -- A64
    # Memory Set with tag setting, unprivileged and non-temporal
    # SETGETN  [<Xd>]!, <Xn>!, <Xs>
    # SETGMTN  [<Xd>]!, <Xn>!, <Xs>
    # SETGPTN  [<Xd>]!, <Xn>!, <Xs>
    class SETGPTN
      def encode
        raise NotImplementedError
      end

      private

      def SETGPTN sz, rs, rn, rd
        insn = 0b00_011_1_01_11_0_00000_xx11_01_00000_00000
        insn |= ((sz & 0x3) << 30)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
