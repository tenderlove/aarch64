module AArch64
  module Instructions
    # ADDS (shifted register) -- A64
    # Add (shifted register), setting flags
    # ADDS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # ADDS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class ADDS_addsub_shift < Instruction
      def initialize xd, xn, xm, shift, amount, sf
        @xd     = check_mask(xd, 0x1f)
        @xn     = check_mask(xn, 0x1f)
        @xm     = check_mask(xm, 0x1f)
        @shift  = check_mask(shift, 0x03)
        @amount = check_mask(amount, 0x3f)
        @sf     = check_mask(sf, 0x01)
      end

      def encode
        ADDS_addsub_shift(@sf, @shift, @xm, @amount, @xn, @xd)
      end

      private

      def ADDS_addsub_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_0_1_01011_00_0_00000_000000_00000_00000
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
