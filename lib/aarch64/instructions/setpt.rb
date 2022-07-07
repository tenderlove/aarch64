module AArch64
  module Instructions
    # SETPT, SETMT, SETET -- A64
    # Memory Set, unprivileged
    # SETET  [<Xd>]!, <Xn>!, <Xs>
    # SETMT  [<Xd>]!, <Xn>!, <Xs>
    # SETPT  [<Xd>]!, <Xn>!, <Xs>
    class SETPT < Instruction
      def encode
        raise NotImplementedError
      end

      private

      def SETPT sz, rs, rn, rd
        insn = 0b00_011_0_01_11_0_00000_xx01_01_00000_00000
        insn |= ((sz & 0x3) << 30)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
