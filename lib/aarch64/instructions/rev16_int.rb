module AArch64
  module Instructions
    # REV16 -- A64
    # Reverse bytes in 16-bit halfwords
    # REV16  <Wd>, <Wn>
    # REV16  <Xd>, <Xn>
    class REV16_int
      def encode
        raise NotImplementedError
      end

      private

      def REV16_int sf, rn, rd
        insn = 0b0_1_0_11010110_00000_0000_01_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
