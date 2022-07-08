module AArch64
  module Instructions
    # STP -- A64
    # Store Pair of Registers
    # STP  <Wt1>, <Wt2>, [<Xn|SP>], #<imm>
    # STP  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # STP  <Wt1>, <Wt2>, [<Xn|SP>, #<imm>]!
    # STP  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # STP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # STP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class STP_gen < Instruction
      def initialize rt, rt2, rn, imm7, opc, option
        @rt     = rt
        @rt2    = rt2
        @rn     = rn
        @imm7   = imm7
        @opc    = opc
        @option = option
      end

      def encode
        STP_gen(@opc, @option, @imm7, @rt2.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def STP_gen opc, option, imm7, rt2, rn, rt
        insn = 0b00_101_0_000_0_0000000_00000_00000_00000
        insn |= ((apply_mask(opc, 0x3)) << 30)
        insn |= ((apply_mask(option, 0x7)) << 23)
        insn |= ((apply_mask(imm7, 0x7f)) << 15)
        insn |= ((apply_mask(rt2, 0x1f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
