module AArch64
  module Instructions
    # STRH (register) -- A64
    # Store Register Halfword (register)
    # STRH  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class STRH_reg
      def initialize rt, rn, rm, option, s
        @rt     = rt
        @rn     = rn
        @rm     = rm
        @option = option
        @s      = s
      end

      def encode
        self.STRH_reg(@rm.to_i, @option, @s, @rn.to_i, @rt.to_i)
      end

      private

      def STRH_reg rm, option, s, rn, rt
        insn = 0b01_111_0_00_00_1_00000_000_0_10_00000_00000
        insn |= ((rm & 0x1f) << 16)
        insn |= ((option & 0x7) << 13)
        insn |= ((s & 0x1) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
