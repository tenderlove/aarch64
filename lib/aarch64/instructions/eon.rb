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

      def encode
        EON(@sf, @shift, @rm, @imm, @rn, @rd)
      end

      private

      def EON sf, shift, rm, imm6, rn, rd
        insn = 0b0_10_01010_00_1_00000_000000_00000_00000
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
