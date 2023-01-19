module AArch64
  module Instructions
    # EON (shifted register) -- A64
    # Bitwise Exclusive OR NOT (shifted register)
    # EON  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # EON  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class EON < Instruction
      def initialize rd, rn, rm, shift, imm, sf
        @rd    = check_mask(rd, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @rm    = check_mask(rm, 0x1f)
        @shift = check_mask(shift, 0x03)
        @imm   = check_mask(imm, 0x3f)
        @sf    = check_mask(sf, 0x01)
      end

      def encode _
        EON(@sf, @shift, @rm, @imm, @rn, @rd)
      end

      private

      def EON sf, shift, rm, imm6, rn, rd
        insn = 0b0_10_01010_00_1_00000_000000_00000_00000
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
