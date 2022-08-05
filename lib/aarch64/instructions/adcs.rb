module AArch64
  module Instructions
    # ADCS -- A64
    # Add with Carry, setting flags
    # ADCS  <Wd>, <Wn>, <Wm>
    class ADCS < Instruction
      def initialize rd, rn, rm, sf
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
        @sf = check_mask(sf, 0x01)
      end

      def encode
        ADCS(@sf, @rm, @rn, @rd)
      end

      private

      def ADCS sf, rm, rn, rd
        insn = 0b0_0_1_11010000_00000_000000_00000_00000
        insn |= ((sf) << 31)
        insn |= ((rm) << 16)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
