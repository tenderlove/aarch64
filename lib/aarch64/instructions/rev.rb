module AArch64
  module Instructions
    # REV -- A64
    # Reverse Bytes
    # REV  <Wd>, <Wn>
    # REV  <Xd>, <Xn>
    class REV < Instruction
      def initialize rd, rn, sf, opc
        @rd  = check_mask(rd, 0x1f)
        @rn  = check_mask(rn, 0x1f)
        @sf  = check_mask(sf, 0x01)
        @opc = check_mask(opc, 0x03)
      end

      def encode
        REV(@sf, @rn, @rd, @opc)
      end

      private

      def REV sf, rn, rd, opc
        insn = 0b0_1_0_11010110_00000_0000_00_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(opc, 0x3)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
