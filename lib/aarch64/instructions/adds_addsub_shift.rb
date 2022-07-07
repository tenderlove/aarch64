module AArch64
  module Instructions
    # ADDS (shifted register) -- A64
    # Add (shifted register), setting flags
    # ADDS  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # ADDS  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class ADDS_addsub_shift < Instruction
      def initialize xd, xn, xm, shift, amount, sf
        @xd     = xd
        @xn     = xn
        @xm     = xm
        @shift  = shift
        @amount = amount
        @sf     = sf
      end

      def encode
        ADDS_addsub_shift(@sf, @shift, @xm.to_i, @amount, @xn.to_i, @xd.to_i)
      end

      private

      def ADDS_addsub_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_0_1_01011_00_0_00000_000000_00000_00000
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
