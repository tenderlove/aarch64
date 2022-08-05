module AArch64
  module Instructions
    # SUBS (shifted register) -- A64
    # Subtract (shifted register), setting flags
    # SUBS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # SUBS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class SUBS_addsub_shift < Instruction
      def initialize rd, rn, rm, shift, amount, sf
        @rd     = check_mask(rd, 0x1f)
        @rn     = check_mask(rn, 0x1f)
        @rm     = check_mask(rm, 0x1f)
        @shift  = check_mask(shift, 0x03)
        @amount = check_mask(amount, 0x3f)
        @sf     = check_mask(sf, 0x01)
      end

      def encode
        SUBS_addsub_shift(@sf, @shift, @rm, @amount, @rn, @rd)
      end

      private

      def SUBS_addsub_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_1_1_01011_00_0_00000_000000_00000_00000
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
