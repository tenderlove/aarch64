module AArch64
  module Instructions
    # ADC -- A64
    # Add with Carry
    # ADC  <Wd>, <Wn>, <Wm>
    # ADC  <Xd>, <Xn>, <Xm>
    class ADC
      def encode
        raise NotImplementedError
      end

      private

      def ADC sf, rm, rn, rd
        insn = 0b0_0_0_11010000_00000_000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
