module AArch64
  module Instructions
    # BIC (shifted register) -- A64
    # Bitwise Bit Clear (shifted register)
    # BIC  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # BIC  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class BIC_log_shift < Instruction
      def initialize d, n, m, shift, amount, sf
        @d      = d
        @n      = n
        @m      = m
        @shift  = shift
        @amount = amount
        @sf     = sf
      end

      def encode
        BIC_log_shift(@sf, @shift, @m.to_i, @amount, @n.to_i, @d.to_i)
      end

      private

      def BIC_log_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_00_01010_00_1_00000_000000_00000_00000
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
