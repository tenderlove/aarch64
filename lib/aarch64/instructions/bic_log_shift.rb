module AArch64
  module Instructions
    # BIC (shifted register) -- A64
    # Bitwise Bit Clear (shifted register)
    # BIC  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # BIC  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class BIC_log_shift < Instruction
      def initialize d, n, m, shift, amount, sf
        @d      = check_mask(d, 0x1f)
        @n      = check_mask(n, 0x1f)
        @m      = check_mask(m, 0x1f)
        @shift  = check_mask(shift, 0x03)
        @amount = check_mask(amount, 0x3f)
        @sf     = check_mask(sf, 0x01)
      end

      def encode
        BIC_log_shift(@sf, @shift, @m, @amount, @n, @d)
      end

      private

      def BIC_log_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_00_01010_00_1_00000_000000_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(shift, 0x3)) << 22)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(imm6, 0x3f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
