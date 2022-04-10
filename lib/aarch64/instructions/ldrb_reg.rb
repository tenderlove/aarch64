module AArch64
  module Instructions
    # LDRB (register) -- A64
    # Load Register Byte (register)
    # LDRB  <Wt>, [<Xn|SP>, (<Wm>|<Xm>), <extend> {<amount>}]
    # LDRB  <Wt>, [<Xn|SP>, <Xm>{, LSL <amount>}]
    class LDRB_reg
      def initialize rt, rn, rm, s, option
        @rt     = rt
        @rn     = rn
        @rm     = rm
        @s      = s
        @option = option
      end

      def encode
        self.LDRB_reg(@rm.to_i, @option, @s, @rn.to_i, @rt.to_i)
      end

      private

      def LDRB_reg rm, option, s, rn, rt
        insn = 0b00_111_0_00_01_1_00000_000_0_10_00000_00000
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
