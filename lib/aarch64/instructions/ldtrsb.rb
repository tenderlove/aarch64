module AArch64
  module Instructions
    # LDTRSB -- A64
    # Load Register Signed Byte (unprivileged)
    # LDTRSB  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDTRSB  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDTRSB
      def encode
        raise NotImplementedError
      end

      private

      def LDTRSB imm9, rn, rt
        insn = 0b00_111_0_00_1x_0_000000000_10_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
