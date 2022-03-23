module AArch64
  module Instructions
    # LDAPURSB -- A64
    # Load-Acquire RCpc Register Signed Byte (unscaled)
    # LDAPURSB  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPURSB  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDAPURSB
      def encode
        raise NotImplementedError
      end

      private

      def LDAPURSB imm9, rn, rt
        insn = 0b00_011001_1x_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
