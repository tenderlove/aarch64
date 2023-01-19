module AArch64
  module Instructions
    # LDP -- A64
    # Load Pair of Registers
    # LDP  <Wt1>, <Wt2>, [<Xn|SP>], #<imm>
    # LDP  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # LDP  <Wt1>, <Wt2>, [<Xn|SP>, #<imm>]!
    # LDP  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # LDP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # LDP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class LDP_gen < Instruction
      def initialize rt, rt2, rn, imm7, mode, opc
        @rt   = check_mask(rt, 0x1f)
        @rt2  = check_mask(rt2, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm7 = check_mask(imm7, 0x7f)
        @mode = check_mask(mode, 0x07)
        @opc  = check_mask(opc, 0x03)
      end

      def encode _
        LDP_gen(@opc, @mode, @imm7, @rt2, @rn, @rt)
      end

      private

      def LDP_gen opc, mode, imm7, rt2, rn, rt
        insn = 0b00_101_0_000_1_0000000_00000_00000_00000
        insn |= ((opc) << 30)
        insn |= ((mode) << 23)
        insn |= ((imm7) << 15)
        insn |= ((rt2) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
