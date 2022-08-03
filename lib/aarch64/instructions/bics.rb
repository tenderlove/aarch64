module AArch64
  module Instructions
    # BICS (shifted register) -- A64
    # Bitwise Bit Clear (shifted register), setting flags
    # BICS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # BICS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class BICS < Instruction
      def initialize d, n, m, shift, amount, sf
        @d      = d
        @n      = n
        @m      = m
        @shift  = shift
        @amount = amount
        @sf     = sf
      end

      def encode
        BICS(@sf, @shift, @m, @amount, @n, @d)
      end

      private

      def BICS sf, shift, rm, imm6, rn, rd
        insn = 0b0_11_01010_00_1_00000_000000_00000_00000
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
