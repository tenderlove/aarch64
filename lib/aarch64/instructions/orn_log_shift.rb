module AArch64
  module Instructions
    # ORN (shifted register) -- A64
    # Bitwise OR NOT (shifted register)
    # ORN  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # ORN  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class ORN_log_shift < Instruction
      def initialize rd, rn, rm, shift, imm6, sf
        @rd    = check_mask(rd, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @rm    = check_mask(rm, 0x1f)
        @shift = check_mask(shift, 0x03)
        @imm6  = check_mask(imm6, 0x3f)
        @sf    = check_mask(sf, 0x01)
      end

      def encode
        ORN_log_shift(@sf, @shift, @rm, @imm6, @rn, @rd)
      end

      private

      def ORN_log_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_01_01010_00_1_00000_000000_00000_00000
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
