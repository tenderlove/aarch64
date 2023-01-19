module AArch64
  module Instructions
    # CRC32B, CRC32H, CRC32W, CRC32X -- A64
    # CRC32 checksum
    # CRC32B  <Wd>, <Wn>, <Wm>
    # CRC32H  <Wd>, <Wn>, <Wm>
    # CRC32W  <Wd>, <Wn>, <Wm>
    # CRC32X  <Wd>, <Wn>, <Xm>
    class CRC32 < Instruction
      def initialize rd, rn, rm, sz, sf
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
        @sz = check_mask(sz, 0x03)
        @sf = check_mask(sf, 0x01)
      end

      def encode _
        CRC32(@sf, @rm, @sz, @rn, @rd)
      end

      private

      def CRC32 sf, rm, sz, rn, rd
        insn = 0b0_0_0_11010110_00000_010_0_00_00000_00000
        insn |= ((sf) << 31)
        insn |= ((rm) << 16)
        insn |= ((sz) << 10)
        insn |= ((rn) << 5)
        insn |= (rd)
        insn
      end
    end
  end
end
