module AArch64
  module Instructions
    # STR (register) -- A64
    # Store Register (register)
    # STR  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    # STR  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class STR_reg_gen
      def initialize rt, rn, rm, option, s, size
        @rt     = rt
        @rn     = rn
        @rm     = rm
        @option = option
        @s      = s
        @size   = size
      end

      def encode
        STR_reg_gen(@size, @rm.to_i, @option, @s, @rn.to_i, @rt.to_i)
      end

      private

      def STR_reg_gen size, rm, option, s, rn, rt
        insn = 0b00_111_0_00_00_1_00000_000_0_10_00000_00000
        insn |= ((size & 0x3) << 30)
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
