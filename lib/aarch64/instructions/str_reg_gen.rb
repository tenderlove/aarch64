module AArch64
  module Instructions
    # STR (register) -- A64
    # Store Register (register)
    # STR  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    # STR  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class STR_reg_gen < Instruction
      def initialize rt, rn, rm, option, s, size
        @rt     = check_mask(rt, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @rm     = check_mask(rm, 0x1f)
        @option = check_mask(option, 0x07)
        @s      = check_mask(s, 0x01)
        @size   = check_mask(size, 0x03)
      end

      def encode
        STR_reg_gen(@size, @rm, @option, @s, @rn, @rt)
      end

      private

      def STR_reg_gen size, rm, option, s, rn, rt
        insn = 0b00_111_0_00_00_1_00000_000_0_10_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
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
