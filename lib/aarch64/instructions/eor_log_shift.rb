module AArch64
  module Instructions
    # EOR (shifted register) -- A64
    # Bitwise Exclusive OR (shifted register)
    # EOR  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # EOR  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class EOR_log_shift
      def initialize rd, rn, rm, shift, imm6, sf
        @rd    = rd
        @rn    = rn
        @rm    = rm
        @shift = shift
        @imm6  = imm6
        @sf    = sf
      end

      def encode
        EOR_log_shift(@sf, @shift, @rm.to_i, @imm6, @rn.to_i, @rd.to_i)
      end

      private

      def EOR_log_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_10_01010_00_0_00000_000000_00000_00000
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
