module AArch64
  module Instructions
    # SUB (shifted register) -- A64
    # Subtract (shifted register)
    # SUB  <Wd>, <Wn>, <Wm>{, <shift> #<amount>}
    # SUB  <Xd>, <Xn>, <Xm>{, <shift> #<amount>}
    class SUB_addsub_shift < Instruction
      def initialize rd, rn, rm, shift, amount, sf
        @rd     = rd
        @rn     = rn
        @rm     = rm
        @shift  = shift
        @amount = amount
        @sf     = sf
      end

      def encode
        SUB_addsub_shift(@sf, @shift, @rm, @amount, @rn, @rd)
      end

      private

      def SUB_addsub_shift sf, shift, rm, imm6, rn, rd
        insn = 0b0_1_0_01011_00_0_00000_000000_00000_00000
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
