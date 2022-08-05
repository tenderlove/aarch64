module AArch64
  module Instructions
    # LDRH (register) -- A64
    # Load Register Halfword (register)
    # LDRH  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class LDRH_reg < Instruction
      def initialize rt, rn, rm, s, option
        @rt     = check_mask(rt, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @rm     = check_mask(rm, 0x1f)
        @s      = check_mask(s, 0x01)
        @option = check_mask(option, 0x07)
      end

      def encode
        LDRH_reg(@rm, @option, @s, @rn, @rt)
      end

      private

      def LDRH_reg rm, option, s, rn, rt
        insn = 0b01_111_0_00_01_1_00000_000_0_10_00000_00000
        insn |= ((rm) << 16)
        insn |= ((option) << 13)
        insn |= ((s) << 12)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
