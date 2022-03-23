module AArch64
  module Instructions
    # STTR -- A64
    # Store Register (unprivileged)
    # STTR  <Wt>, [<Xn|SP>{, #<simm>}]
    # STTR  <Xt>, [<Xn|SP>{, #<simm>}]
    class STTR
      def encode
        raise NotImplementedError
      end

      private

      def STTR imm9, rn, rt
        insn = 0b1x_111_0_00_00_0_000000000_10_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
