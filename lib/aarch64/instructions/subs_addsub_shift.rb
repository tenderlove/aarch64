module AArch64
  module Instructions
    # SUBS (shifted register) -- A64
    # Subtract (shifted register), setting flags
    # SUBS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # SUBS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class SUBS_addsub_shift
      def initialize rd, rn, rm, shift, amount, sf
        @rd     = rd
        @rn     = rn
        @rm     = rm
        @shift  = shift
        @amount = amount
        @sf     = sf
      end

      def encode
        SUBS_addsub_shift(@sf, @shift, @rm.to_i, @amount, @rn.to_i, @rd.to_i)
      end

      private

      def SUBS_addsub_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_1_1_01011_00_0_00000_000000_00000_00000
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
