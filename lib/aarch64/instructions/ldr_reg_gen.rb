module AArch64
  module Instructions
    # LDR (register) -- A64
    # Load Register (register)
    # LDR  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    # LDR  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class LDR_reg_gen < Instruction
      def initialize rt, rn, rm, size, option, s
        @rt     = check_mask(rt, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @rm     = check_mask(rm, 0x1f)
        @size   = check_mask(size, 0x03)
        @option = check_mask(option, 0x07)
        @s      = check_mask(s, 0x01)
      end

      def encode _
        LDR_reg_gen(@size, @rm, @option, @s, @rn, @rt)
      end

      private

      def LDR_reg_gen size, rm, option, s, rn, rt
        insn = 0b00_111_0_00_01_1_00000_000_0_10_00000_00000
        insn |= ((size) << 30)
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
