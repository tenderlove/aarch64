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
    class LDP_gen
      def initialize rt, rt2, rn, imm7, mode, opc
        @rt   = rt
        @rt2  = rt2
        @rn   = rn
        @imm7 = imm7
        @mode = mode
        @opc  = opc
      end

      def encode
        LDP_gen(@opc, @mode, @imm7, @rt2.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDP_gen opc, mode, imm7, rt2, rn, rt
        insn = 0b00_101_0_000_1_0000000_00000_00000_00000
        insn |= ((opc & 0x3) << 30)
        insn |= ((mode & 0x7) << 23)
        insn |= ((imm7 & 0x7f) << 15)
        insn |= ((rt2 & 0x1f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
