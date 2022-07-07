module AArch64
  module Instructions
    # SETPN, SETMN, SETEN -- A64
    # Memory Set, non-temporal
    # SETEN  [<Xd>]!, <Xn>!, <Xs>
    # SETMN  [<Xd>]!, <Xn>!, <Xs>
    # SETPN  [<Xd>]!, <Xn>!, <Xs>
    class SETPN < Instruction
      def encode
        raise NotImplementedError
      end

      private

      def SETPN sz, rs, rn, rd
        insn = 0b00_011_0_01_11_0_00000_xx10_01_00000_00000
        insn |= ((sz & 0x3) << 30)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
