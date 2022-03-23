module AArch64
  module Instructions
    # LDAPUR -- A64
    # Load-Acquire RCpc Register (unscaled)
    # LDAPUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPUR  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDAPUR_gen
      def encode
        raise NotImplementedError
      end

      private

      def LDAPUR_gen imm9, rn, rt
        insn = 0b1x_011001_01_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
