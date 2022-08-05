module AArch64
  module Instructions
    # LDRSW (immediate) -- A64
    # Load Register Signed Word (immediate)
    # LDRSW  <Xt>, [<Xn|SP>], #<simm>
    # LDRSW  <Xt>, [<Xn|SP>, #<simm>]!
    # LDRSW  <Xt>, [<Xn|SP>{, #<pimm>}]
    class LDRSW_imm < Instruction
      def initialize rt, rn, imm9, option
        @rt     = check_mask(rt, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @imm9   = check_mask(imm9, 0x1ff)
        @option = check_mask(option, 0x03)
      end

      def encode
        LDRSW_imm(@imm9, @rn, @rt, @option)
      end

      private

      def LDRSW_imm imm9, rn, rt, option
        insn = 0b10_111_0_00_10_0_000000000_01_00000_00000
        insn |= ((imm9) << 12)
        insn |= ((option) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
