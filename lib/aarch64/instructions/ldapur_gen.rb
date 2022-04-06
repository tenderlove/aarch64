module AArch64
  module Instructions
    # LDAPUR -- A64
    # Load-Acquire RCpc Register (unscaled)
    # LDAPUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPUR  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDAPUR_gen
      def initialize size, opc, rt, rn, simm
        @size = size
        @opc  = opc
        @rt   = rt
        @rn   = rn
        @simm = simm
      end

      def encode
        self.LDAPUR_gen(@size, @opc, @simm, @rn.to_i, @rt.to_i)
      end

      private

      def LDAPUR_gen size, opc, imm9, rn, rt
        insn = 0b00_011001_00_0_000000000_00_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((opc & 0x3) << 22)
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
