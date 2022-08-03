module AArch64
  module Instructions
    # LDRH (immediate) -- A64
    # Load Register Halfword (immediate)
    # LDRH  <Wt>, [<Xn|SP>], #<simm>
    # LDRH  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRH  <Wt>, [<Xn|SP>{, #<pimm>}]
    class LDRH_imm < Instruction
      def initialize rt, rn, imm9, option
        @rt     = rt
        @rn     = rn
        @imm9   = imm9
        @option = option
      end

      def encode
        LDRH_imm(@imm9, @option, @rn, @rt)
      end

      private

      def LDRH_imm imm9, option, rn, rt
        insn = 0b01_111_0_00_01_0_000000000_01_00000_00000
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(option, 0x3)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
