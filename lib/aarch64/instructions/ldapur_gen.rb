module AArch64
  module Instructions
    # LDAPUR -- A64
    # Load-Acquire RCpc Register (unscaled)
    # LDAPUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDAPUR  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDAPUR_gen < Instruction
      def initialize size, opc, rt, rn, simm
        @size = check_mask(size, 0x03)
        @opc  = check_mask(opc, 0x03)
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @simm = check_mask(simm, 0x1ff)
      end

      def encode _
        LDAPUR_gen(@size, @opc, @simm, @rn, @rt)
      end

      private

      def LDAPUR_gen size, opc, imm9, rn, rt
        insn = 0b00_011001_00_0_000000000_00_00000_00000
        insn |= ((size) << 30)
        insn |= ((opc) << 22)
        insn |= ((imm9) << 12)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
