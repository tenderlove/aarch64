module AArch64
  module Instructions
    # STRH (immediate) -- A64
    # Store Register Halfword (immediate)
    # STRH  <Wt>, [<Xn|SP>], #<simm>
    # STRH  <Wt>, [<Xn|SP>, #<simm>]!
    # STRH  <Wt>, [<Xn|SP>{, #<pimm>}]
    class STRH_imm
      def initialize rt, rn, imm9, opt
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
        @opt  = opt
      end

      def encode
        STRH_imm(@imm9, @opt, @rn.to_i, @rt.to_i)
      end

      private

      def STRH_imm imm9, opt, rn, rt
        insn = 0b01_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((opt & 0x3) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
