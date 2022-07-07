module AArch64
  module Instructions
    # SETP, SETM, SETE -- A64
    # Memory Set
    # SETE  [<Xd>]!, <Xn>!, <Xs>
    # SETM  [<Xd>]!, <Xn>!, <Xs>
    # SETP  [<Xd>]!, <Xn>!, <Xs>
    class SETP < Instruction
      def encode
        raise NotImplementedError
      end

      private

      def SETP sz, rs, rn, rd
        insn = 0b00_011_0_01_11_0_00000_xx00_01_00000_00000
        insn |= ((sz & 0x3) << 30)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
