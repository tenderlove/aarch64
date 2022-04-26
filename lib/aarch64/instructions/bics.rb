module AArch64
  module Instructions
    # BICS (shifted register) -- A64
    # Bitwise Bit Clear (shifted register), setting flags
    # BICS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # BICS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class BICS
      def initialize d, n, m, shift, amount, sf
        @d      = d
        @n      = n
        @m      = m
        @shift  = shift
        @amount = amount
        @sf     = sf
      end

      def encode
        BICS(@sf, @shift, @m.to_i, @amount, @n.to_i, @d.to_i)
      end

      private

      def BICS sf, shift, rm, imm6, rn, rd
        insn = 0b0_11_01010_00_1_00000_000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((shift & 0x3) << 22)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((imm6 & 0x3f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
