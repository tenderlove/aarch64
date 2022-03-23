module AArch64
  module Instructions
    # PRFM (register) -- A64
    # Prefetch Memory (register)
    # PRFM  (<prfop>|#<imm5>), [<Xn|SP>, (<Wm>|<Xm>){, <extend> {<amount>}}]
    class PRFM_reg
      def encode
        raise NotImplementedError
      end

      private

      def PRFM_reg rm, option, s, rn, rt
        insn = 0b11_111_0_00_10_1_00000_000_0_10_00000_00000
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
