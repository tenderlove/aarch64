module AArch64
  module Instructions
    # LDRSW (immediate) -- A64
    # Load Register Signed Word (immediate)
    # LDRSW  <Xt>, [<Xn|SP>], #<simm>
    # LDRSW  <Xt>, [<Xn|SP>, #<simm>]!
    # LDRSW  <Xt>, [<Xn|SP>{, #<pimm>}]
    class LDRSW_imm
      def initialize rt, rn, imm9, option
        @rt     = rt
        @rn     = rn
        @imm9   = imm9
        @option = option
      end

      def encode
        LDRSW_imm(@imm9, @rn.to_i, @rt.to_i, @option)
      end

      private

      def LDRSW_imm imm9, rn, rt, option
        insn = 0b10_111_0_00_10_0_000000000_01_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((option & 0x3) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
