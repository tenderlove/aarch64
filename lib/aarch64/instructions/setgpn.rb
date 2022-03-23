module AArch64
  module Instructions
    # SETGPN, SETGMN, SETGEN -- A64
    # Memory Set with tag setting, non-temporal
    # SETGEN  [<Xd>]!, <Xn>!, <Xs>
    # SETGMN  [<Xd>]!, <Xn>!, <Xs>
    # SETGPN  [<Xd>]!, <Xn>!, <Xs>
    class SETGPN
      def encode
        raise NotImplementedError
      end

      private

      def SETGPN sz, rs, rn, rd
        insn = 0b00_011_1_01_11_0_00000_xx10_01_00000_00000
        insn |= ((sz & 0x3) << 30)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
