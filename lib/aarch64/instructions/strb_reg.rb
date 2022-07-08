module AArch64
  module Instructions
    # STRB (register) -- A64
    # Store Register Byte (register)
    # STRB  <Wt>, [<Xn|SP>, (<Wm>|<Xm>), <extend> {<amount>}]
    # STRB  <Wt>, [<Xn|SP>, <Xm>{, LSL <amount>}]
    class STRB_reg < Instruction
      def initialize rt, rn, rm, option, s
        @rt     = rt
        @rn     = rn
        @rm     = rm
        @option = option
        @s      = s
      end

      def encode
        STRB_reg(@rm.to_i, @option, @s, @rn.to_i, @rt.to_i)
      end

      private

      def STRB_reg rm, option, s, rn, rt
        insn = 0b00_111_0_00_00_1_00000_000_0_10_00000_00000
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
