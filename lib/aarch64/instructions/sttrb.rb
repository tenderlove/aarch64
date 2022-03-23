module AArch64
  module Instructions
    # STTRB -- A64
    # Store Register Byte (unprivileged)
    # STTRB  <Wt>, [<Xn|SP>{, #<simm>}]
    class STTRB
      def encode
        raise NotImplementedError
      end

      private

      def STTRB imm9, rn, rt
        insn = 0b00_111_0_00_00_0_000000000_10_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
