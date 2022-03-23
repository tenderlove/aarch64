module AArch64
  module Instructions
    # RBIT -- A64
    # Reverse Bits
    # RBIT  <Wd>, <Wn>
    # RBIT  <Xd>, <Xn>
    class RBIT_int
      def encode
        raise NotImplementedError
      end

      private

      def RBIT_int sf, rn, rd
        insn = 0b0_1_0_11010110_00000_0000_00_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
