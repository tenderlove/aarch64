module AArch64
  module Instructions
    # STLURH -- A64
    # Store-Release Register Halfword (unscaled)
    # STLURH  <Wt>, [<Xn|SP>{, #<simm>}]
    class STLURH
      def encode
        raise NotImplementedError
      end

      private

      def STLURH imm9, rn, rt
        insn = 0b01_011001_00_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
