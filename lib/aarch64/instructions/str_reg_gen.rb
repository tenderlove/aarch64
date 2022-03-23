module AArch64
  module Instructions
    # STR (register) -- A64
    # Store Register (register)
    # STR  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    # STR  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class STR_reg_gen
      def encode
        raise NotImplementedError
      end

      private

      def STR_reg_gen rm, option, s, rn, rt
        insn = 0b1x_111_0_00_00_1_00000_000_0_10_00000_00000
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
