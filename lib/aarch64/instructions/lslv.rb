module AArch64
  module Instructions
    # LSLV -- A64
    # Logical Shift Left Variable
    # LSLV  <Wd>, <Wn>, <Wm>
    # LSLV  <Xd>, <Xn>, <Xm>
    class LSLV < Instruction
      def initialize rd, rn, rm, sf
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
        @sf = check_mask(sf, 0x01)
      end

      def encode
        LSLV(@sf, @rm, @rn, @rd)
      end

      private

      def LSLV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_0010_00_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
