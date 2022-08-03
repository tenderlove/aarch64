module AArch64
  module Instructions
    # PRFM (register) -- A64
    # Prefetch Memory (register)
    # PRFM  (<prfop>|#<imm5>), [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class PRFM_reg < Instruction
      def initialize rt, rn, rm, option, s
        @rt     = rt
        @rn     = rn
        @rm     = rm
        @option = option
        @s      = s
      end

      def encode
        PRFM_reg(@rm, @option, @s, @rn, @rt)
      end

      private

      def PRFM_reg rm, option, s, rn, rt
        insn = 0b11_111_0_00_10_1_00000_000_0_10_00000_00000
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(option, 0x7)) << 13)
        insn |= ((apply_mask(s, 0x1)) << 12)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
