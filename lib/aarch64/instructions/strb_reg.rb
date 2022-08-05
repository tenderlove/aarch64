module AArch64
  module Instructions
    # STRB (register) -- A64
    # Store Register Byte (register)
    # STRB  <Wt>, [<Xn|SP>, (<Wm>|<Xm>), <extend> {<amount>}]
    # STRB  <Wt>, [<Xn|SP>, <Xm>{, LSL <amount>}]
    class STRB_reg < Instruction
      def initialize rt, rn, rm, option, s
        @rt     = check_mask(rt, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @rm     = check_mask(rm, 0x1f)
        @option = check_mask(option, 0x07)
        @s      = check_mask(s, 0x01)
      end

      def encode
        STRB_reg(@rm, @option, @s, @rn, @rt)
      end

      private

      def STRB_reg rm, option, s, rn, rt
        insn = 0b00_111_0_00_00_1_00000_000_0_10_00000_00000
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
