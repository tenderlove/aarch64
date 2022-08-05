module AArch64
  module Instructions
    # LSRV -- A64
    # Logical Shift Right Variable
    # LSRV  <Wd>, <Wn>, <Wm>
    # LSRV  <Xd>, <Xn>, <Xm>
    class LSRV < Instruction
      def initialize rd, rn, rm, sf
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
        @sf = check_mask(sf, 0x01)
      end

      def encode
        LSRV(@sf, @rm, @rn, @rd)
      end

      private

      def LSRV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_0010_01_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
