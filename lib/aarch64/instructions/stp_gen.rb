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
        @rt     = check_mask(rt, 0x1f)
        @rt2    = check_mask(rt2, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @imm7   = check_mask(imm7, 0x7f)
        @opc    = check_mask(opc, 0x03)
        @option = check_mask(option, 0x07)
      end

      def encode
        STP_gen(@opc, @option, @imm7, @rt2, @rn, @rt)
      end

      private

      def STP_gen opc, option, imm7, rt2, rn, rt
        insn = 0b00_101_0_000_0_0000000_00000_00000_00000
        insn |= ((opc) << 30)
        insn |= ((option) << 23)
        insn |= ((imm7) << 15)
        insn |= ((rt2) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
