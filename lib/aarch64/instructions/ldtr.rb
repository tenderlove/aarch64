module AArch64
  module Instructions
    # LDTR -- A64
    # Load Register (unprivileged)
    # LDTR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDTR  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDTR
      def encode
        raise NotImplementedError
      end

      private

      def LDTR imm9, rn, rt
        insn = 0b1x_111_0_00_01_0_000000000_10_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
