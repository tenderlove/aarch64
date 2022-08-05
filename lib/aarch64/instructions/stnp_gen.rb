module AArch64
  module Instructions
    # STNP -- A64
    # Store Pair of Registers, with non-temporal hint
    # STNP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # STNP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class STNP_gen < Instruction
      def initialize rt, rt2, rn, imm7, opc
        @rt   = check_mask(rt, 0x1f)
        @rt2  = check_mask(rt2, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm7 = check_mask(imm7, 0x7f)
        @opc  = check_mask(opc, 0x03)
      end

      def encode
        STNP_gen(@opc, @imm7, @rt2, @rn, @rt)
      end

      private

      def STNP_gen opc, imm7, rt2, rn, rt
        insn = 0b00_101_0_000_0_0000000_00000_00000_00000
        insn |= ((apply_mask(opc, 0x3)) << 30)
        insn |= ((apply_mask(imm7, 0x7f)) << 15)
        insn |= ((apply_mask(rt2, 0x1f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
