module AArch64
  module Instructions
    # CRC32CB, CRC32CH, CRC32CW, CRC32CX -- A64
    # CRC32C checksum
    # CRC32CB  <Wd>, <Wn>, <Wm>
    # CRC32CH  <Wd>, <Wn>, <Wm>
    # CRC32CW  <Wd>, <Wn>, <Wm>
    # CRC32CX  <Wd>, <Wn>, <Xm>
    class CRC32C < Instruction
      def initialize rd, rn, rm, sz, sf
        @rd = rd
        @rn = rn
        @rm = rm
        @sz = sz
        @sf = sf
      end

      def encode
        CRC32C(@sf, @rm.to_i, @sz, @rn.to_i, @rd.to_i)
      end

      private

      def CRC32C sf, rm, sz, rn, rd
        insn = 0b0_0_0_11010110_00000_010_1_00_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((sz & 0x3) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
