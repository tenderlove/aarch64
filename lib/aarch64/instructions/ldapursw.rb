module AArch64
  module Instructions
    # LDAPURSW -- A64
    # Load-Acquire RCpc Register Signed Word (unscaled)
    # LDAPURSW  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDAPURSW
      def encode
        raise NotImplementedError
      end

      private

      def LDAPURSW imm9, rn, rt
        insn = 0b10_011001_10_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
