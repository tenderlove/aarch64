module AArch64
  module Instructions
    # SETGP, SETGM, SETGE -- A64
    # Memory Set with tag setting
    # SETGE  [<Xd>]!, <Xn>!, <Xs>
    # SETGM  [<Xd>]!, <Xn>!, <Xs>
    # SETGP  [<Xd>]!, <Xn>!, <Xs>
    class SETGP < Instruction
      def encode
        raise NotImplementedError
      end

      private

      def SETGP sz, rs, rn, rd
        insn = 0b00_011_1_01_11_0_00000_xx00_01_00000_00000
        insn |= ((sz & 0x3) << 30)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
