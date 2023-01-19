module AArch64
  module Instructions
    # LDRSH (immediate) -- A64
    # Load Register Signed Halfword (immediate)
    # LDRSH  <Wt>, [<Xn|SP>], #<simm>
    # LDRSH  <Xt>, [<Xn|SP>], #<simm>
    # LDRSH  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRSH  <Xt>, [<Xn|SP>, #<simm>]!
    # LDRSH  <Wt>, [<Xn|SP>{, #<pimm>}]
    # LDRSH  <Xt>, [<Xn|SP>{, #<pimm>}]
    class LDRSH_imm < Instruction
      def initialize rt, rn, imm9, option, opc
        @rt     = check_mask(rt, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @imm9   = check_mask(imm9, 0x1ff)
        @option = check_mask(option, 0x03)
        @opc    = check_mask(opc, 0x03)
      end

      def encode _
        LDRSH_imm(@opc, @imm9, @option, @rn, @rt)
      end

      private

      def LDRSH_imm opc, imm9, option, rn, rt
        insn = 0b01_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((opc) << 22)
        insn |= ((imm9) << 12)
        insn |= ((option) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
