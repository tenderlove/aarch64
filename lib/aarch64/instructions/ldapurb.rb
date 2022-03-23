module AArch64
  module Instructions
    # LDAPURB -- A64
    # Load-Acquire RCpc Register Byte (unscaled)
    # LDAPURB  <Wt>, [<Xn|SP>{, #<simm>}]
    class LDAPURB
      def encode
        raise NotImplementedError
      end

      private

      def LDAPURB imm9, rn, rt
        insn = 0b00_011001_01_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
