module AArch64
  module Instructions
    # LDR (register) -- A64
    # Load Register (register)
    # LDR  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    # LDR  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class LDR_reg_gen < Instruction
      def initialize rt, rn, rm, size, option, s
        @rt     = rt
        @rn     = rn
        @rm     = rm
        @size   = size
        @option = option
        @s      = s
      end

      def encode
        LDR_reg_gen(@size, @rm, @option, @s, @rn, @rt)
      end

      private

      def LDR_reg_gen size, rm, option, s, rn, rt
        insn = 0b00_111_0_00_01_1_00000_000_0_10_00000_00000
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
