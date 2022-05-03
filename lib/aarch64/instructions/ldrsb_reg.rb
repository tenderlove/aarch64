module AArch64
  module Instructions
    # LDRSB (register) -- A64
    # Load Register Signed Byte (register)
    # LDRSB  <Wt>, [<Xn|SP>, (<Wm>|<Xm>), <extend> {<amount>}]
    # LDRSB  <Wt>, [<Xn|SP>, <Xm>{, LSL <amount>}]
    # LDRSB  <Xt>, [<Xn|SP>, (<Wm>|<Xm>), <extend> {<amount>}]
    # LDRSB  <Xt>, [<Xn|SP>, <Xm>{, LSL <amount>}]
    class LDRSB_reg
      def initialize rt, rn, rm, s, option, opc
        @rt     = rt
        @rn     = rn
        @rm     = rm
        @s      = s
        @option = option
        @opc    = opc
      end

      def encode
        LDRSB_reg(@opc, @rm.to_i, @option, @s, @rn.to_i, @rt.to_i)
      end

      private

      def LDRSB_reg opc, rm, option, s, rn, rt
        insn = 0b00_111_0_00_00_1_00000_000_0_10_00000_00000
        insn |= ((opc & 0x3) << 22)
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
