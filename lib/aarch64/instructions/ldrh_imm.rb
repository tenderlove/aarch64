module AArch64
  module Instructions
    # LDRH (immediate) -- A64
    # Load Register Halfword (immediate)
    # LDRH  <Wt>, [<Xn|SP>], #<simm>
    # LDRH  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRH  <Wt>, [<Xn|SP>{, #<pimm>}]
    class LDRH_imm < Instruction
      def initialize rt, rn, imm9, option
        @rt     = check_mask(rt, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @imm9   = check_mask(imm9, 0x1ff)
        @option = check_mask(option, 0x03)
      end

      def encode
        LDRH_imm(@imm9, @option, @rn, @rt)
      end

      private

      def LDRH_imm imm9, option, rn, rt
        insn = 0b01_111_0_00_01_0_000000000_01_00000_00000
        insn |= ((imm9) << 12)
        insn |= ((option) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
