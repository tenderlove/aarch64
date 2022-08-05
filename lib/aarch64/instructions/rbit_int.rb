module AArch64
  module Instructions
    # RBIT -- A64
    # Reverse Bits
    # RBIT  <Wd>, <Wn>
    # RBIT  <Xd>, <Xn>
    class RBIT_int < Instruction
      def initialize rd, rn, sf
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @sf = check_mask(sf, 0x01)
      end

      def encode
        RBIT_int(@sf, @rn, @rd)
      end

      private

      def RBIT_int sf, rn, rd
        insn = 0b0_1_0_11010110_00000_0000_00_00000_00000
        insn |= ((sf) << 31)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
