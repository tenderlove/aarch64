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
        @rd = rd
        @rn = rn
        @rm = rm
        @sz = sz
        @sf = sf
      end

      def encode
        CRC32(@sf, @rm.to_i, @sz, @rn.to_i, @rd.to_i)
      end

      private

      def CRC32 sf, rm, sz, rn, rd
        insn = 0b0_0_0_11010110_00000_010_0_00_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(sz, 0x3)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
