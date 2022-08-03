module AArch64
  module Instructions
    # AND (shifted register) -- A64
    # Bitwise AND (shifted register)
    # AND  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # AND  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class AND_log_shift < Instruction
      def initialize xd, xn, xm, shift, amount, sf
        @xd     = xd
        @xn     = xn
        @xm     = xm
        @shift  = shift
        @amount = amount
        @sf     = sf
      end

      def encode
        AND_log_shift(@sf, @shift, @xm, @amount, @xn, @xd)
      end

      private

      def AND_log_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_00_01010_00_0_00000_000000_00000_00000
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
