module AArch64
  module Instructions
    # LDNP -- A64
    # Load Pair of Registers, with non-temporal hint
    # LDNP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # LDNP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class LDNP_gen < Instruction
      def initialize rt1, rt2, rn, imm, opc
        @rt1 = check_mask(rt1, 0x1f)
        @rt2 = check_mask(rt2, 0x1f)
        @rn  = check_mask(rn, 0x1f)
        @imm = check_mask(imm, 0x7f)
        @opc = check_mask(opc, 0x03)
      end

      def encode _
        LDNP_gen(@opc, @imm, @rt2, @rn, @rt1)
      end

      private

      def LDNP_gen opc, imm7, rt2, rn, rt
        insn = 0b00_101_0_000_1_0000000_00000_00000_00000
        insn |= ((opc) << 30)
        insn |= ((imm7) << 15)
        insn |= ((rt2) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
