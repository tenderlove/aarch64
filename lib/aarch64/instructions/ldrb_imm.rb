module AArch64
  module Instructions
    # LDRB (immediate) -- A64
    # Load Register Byte (immediate)
    # LDRB  <Wt>, [<Xn|SP>], #<simm>
    # LDRB  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRB  <Wt>, [<Xn|SP>{, #<pimm>}]
    class LDRB_imm
      def initialize rt, rn, imm9, option
        @rt     = rt
        @rn     = rn
        @imm9   = imm9
        @option = option
      end

      def encode
        self.LDRB_imm(@imm9, @option, @rn.to_i, @rt.to_i)
      end

      private

      def LDRB_imm imm9, option, rn, rt
        insn = 0b00_111_0_00_01_0_000000000_01_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((option & 0x3) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
