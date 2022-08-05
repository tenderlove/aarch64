module AArch64
  module Instructions
    # SDIV -- A64
    # Signed Divide
    # SDIV  <Wd>, <Wn>, <Wm>
    # SDIV  <Xd>, <Xn>, <Xm>
    class SDIV < Instruction
      def initialize rd, rn, rm, sf
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
        @sf = check_mask(sf, 0x01)
      end

      def encode
        SDIV(@sf, @rm, @rn, @rd)
      end

      private

      def SDIV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_00001_1_00000_00000
        insn |= ((sf) << 31)
        insn |= ((rm) << 16)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
