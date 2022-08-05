module AArch64
  module Instructions
    # BICS (shifted register) -- A64
    # Bitwise Bit Clear (shifted register), setting flags
    # BICS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # BICS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class BICS < Instruction
      def initialize d, n, m, shift, amount, sf
        @d      = check_mask(d, 0x1f)
        @n      = check_mask(n, 0x1f)
        @m      = check_mask(m, 0x1f)
        @shift  = check_mask(shift, 0x03)
        @amount = check_mask(amount, 0x3f)
        @sf     = check_mask(sf, 0x01)
      end

      def encode
        BICS(@sf, @shift, @m, @amount, @n, @d)
      end

      private

      def BICS sf, shift, rm, imm6, rn, rd
        insn = 0b0_11_01010_00_1_00000_000000_00000_00000
        insn |= ((sf) << 31)
        insn |= ((shift) << 22)
        insn |= ((rm) << 16)
        insn |= ((imm6) << 10)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
