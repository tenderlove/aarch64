module AArch64
  module Instructions
    # STNP -- A64
    # Store Pair of Registers, with non-temporal hint
    # STNP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # STNP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class STNP_gen < Instruction
      def initialize rt, rt2, rn, imm7, opc
        @rt   = rt
        @rt2  = rt2
        @rn   = rn
        @imm7 = imm7
        @opc  = opc
      end

      def encode
        STNP_gen(@opc, @imm7, @rt2.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def STNP_gen opc, imm7, rt2, rn, rt
        insn = 0b00_101_0_000_0_0000000_00000_00000_00000
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
