module AArch64
  module Instructions
    # LDRSH (register) -- A64
    # Load Register Signed Halfword (register)
    # LDRSH  <Wt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    # LDRSH  <Xt>, [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class LDRSH_reg
      def encode
        raise NotImplementedError
      end

      private

      def LDRSH_reg rm, option, s, rn, rt
        insn = 0b01_111_0_00_1x_1_00000_000_0_10_00000_00000
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
