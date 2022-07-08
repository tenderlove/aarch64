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
        @rt     = rt
        @rn     = rn
        @imm9   = imm9
        @option = option
        @opc    = opc
      end

      def encode
        LDRSH_imm(@opc, @imm9, @option, @rn.to_i, @rt.to_i)
      end

      private

      def LDRSH_imm opc, imm9, option, rn, rt
        insn = 0b01_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((apply_mask(opc, 0x3)) << 22)
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(option, 0x3)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
