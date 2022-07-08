module AArch64
  module Instructions
    # ANDS (shifted register) -- A64
    # Bitwise AND (shifted register), setting flags
    # ANDS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # ANDS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class ANDS_log_shift < Instruction
      def initialize xd, xn, xm, shift, amount, sf
        @xd     = xd
        @xn     = xn
        @xm     = xm
        @shift  = shift
        @amount = amount
        @sf     = sf
      end

      def encode
        ANDS_log_shift(@sf, @shift, @xm.to_i, @amount, @xn.to_i, @xd.to_i)
      end

      private

      def ANDS_log_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_11_01010_00_0_00000_000000_00000_00000
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
