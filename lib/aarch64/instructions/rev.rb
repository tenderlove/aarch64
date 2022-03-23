module AArch64
  module Instructions
    # REV -- A64
    # Reverse Bytes
    # REV  <Wd>, <Wn>
    # REV  <Xd>, <Xn>
    class REV
      def encode
        raise NotImplementedError
      end

      private

      def REV sf, rn, rd
        insn = 0b0_1_0_11010110_00000_0000_1x_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
