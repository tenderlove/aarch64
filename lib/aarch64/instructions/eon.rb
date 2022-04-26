module AArch64
  module Instructions
    # EON (shifted register) -- A64
    # Bitwise Exclusive OR NOT (shifted register)
    # EON  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # EON  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class EON
      def initialize rd, rn, rm, shift, imm, sf
        @rd    = rd
        @rn    = rn
        @rm    = rm
        @shift = shift
        @imm   = imm
        @sf    = sf
      end

      def encode
        self.EON(@sf, @shift, @rm.to_i, @imm, @rn.to_i, @rd.to_i)
      end

      private

      def EON sf, shift, rm, imm6, rn, rd
        insn = 0b0_10_01010_00_1_00000_000000_00000_00000
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
