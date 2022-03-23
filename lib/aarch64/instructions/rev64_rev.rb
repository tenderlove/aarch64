module AArch64
  module Instructions
    # REV64 -- A64
    # Reverse Bytes
    # REV64  <Xd>, <Xn>
    # REV  <Xd>, <Xn>
    class REV64_REV
      def encode
        raise NotImplementedError
      end

      private

      def REV64_REV rn, rd
        insn = 0b1_1_0_11010110_00000_0000_11_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
