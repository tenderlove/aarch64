module AArch64
  module Instructions
    # SUBPS -- A64
    # Subtract Pointer, setting Flags
    # SUBPS  <Xd>, <Xn|SP>, <Xm|SP>
    class SUBPS
      def encode
        raise NotImplementedError
      end

      private

      def SUBPS xm, xn, xd
        insn = 0b1_0_1_11010110_00000_0_0_0_0_0_0_00000_00000
        insn |= ((xm & 0x1f) << 16)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xd & 0x1f)
        insn
      end
    end
  end
end
