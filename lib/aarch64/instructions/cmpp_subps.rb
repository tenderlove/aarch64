module AArch64
  module Instructions
    # CMPP -- A64
    # Compare with Tag
    # CMPP  <Xn|SP>, <Xm|SP>
    # SUBPS XZR, <Xn|SP>, <Xm|SP>
    class CMPP_SUBPS
      def encode
        raise NotImplementedError
      end

      private

      def CMPP_SUBPS xm, xn
        insn = 0b1_0_1_11010110_00000_0_0_0_0_0_0_00000_11111
        insn |= ((xm & 0x1f) << 16)
        insn |= ((xn & 0x1f) << 5)
        insn
      end
    end
  end
end
