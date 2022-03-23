module AArch64
  module Instructions
    # LDAPURSH -- A64
    # Load-Acquire RCpc Register Signed Halfword (unscaled)
    # LDAPURSH  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPURSH  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDAPURSH
      def encode
        raise NotImplementedError
      end

      private

      def LDAPURSH imm9, rn, rt
        insn = 0b01_011001_1x_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
