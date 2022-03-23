module AArch64
  module Instructions
    # REV32 -- A64
    # Reverse bytes in 32-bit words
    # REV32  <Xd>, <Xn>
    class REV32_int
      def encode
        raise NotImplementedError
      end

      private

      def REV32_int rn, rd
        insn = 0b1_1_0_11010110_00000_0000_10_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
