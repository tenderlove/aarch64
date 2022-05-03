module AArch64
  module Instructions
    # REV -- A64
    # Reverse Bytes
    # REV  <Wd>, <Wn>
    # REV  <Xd>, <Xn>
    class REV
      def initialize rd, rn, sf, opc
        @rd  = rd
        @rn  = rn
        @sf  = sf
        @opc = opc
      end

      def encode
        REV(@sf, @rn.to_i, @rd.to_i, @opc)
      end

      private

      def REV sf, rn, rd, opc
        insn = 0b0_1_0_11010110_00000_0000_00_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((opc & 0x3) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
