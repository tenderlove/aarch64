module AArch64
  module Instructions
    # STLURB -- A64
    # Store-Release Register Byte (unscaled)
    # STLURB  <Wt>, [<Xn|SP>{, #<simm>}]
    class STLURB
      def encode
        raise NotImplementedError
      end

      private

      def STLURB imm9, rn, rt
        insn = 0b00_011001_00_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
