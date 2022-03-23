module AArch64
  module Instructions
    # SUBP -- A64
    # Subtract Pointer
    # SUBP  <Xd>, <Xn|SP>, <Xm|SP>
    class SUBP
      def encode
        raise NotImplementedError
      end

      private

      def SUBP xm, xn, xd
        insn = 0b1_0_0_11010110_00000_0_0_0_0_0_0_00000_00000
        insn |= ((xm & 0x1f) << 16)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xd & 0x1f)
        insn
      end
    end
  end
end
