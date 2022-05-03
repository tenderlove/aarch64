module AArch64
  module Instructions
    # LDNP -- A64
    # Load Pair of Registers, with non-temporal hint
    # LDNP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # LDNP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class LDNP_gen
      def initialize rt1, rt2, rn, imm, opc
        @rt1 = rt1
        @rt2 = rt2
        @rn  = rn
        @imm = imm
        @opc = opc
      end

      def encode
        LDNP_gen(@opc, @imm, @rt2.to_i, @rn.to_i, @rt1.to_i)
      end

      private

      def LDNP_gen opc, imm7, rt2, rn, rt
        insn = 0b00_101_0_000_1_0000000_00000_00000_00000
        insn |= ((opc & 0x3) << 30)
        insn |= ((imm7 & 0x7f) << 15)
        insn |= ((rt2 & 0x1f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
