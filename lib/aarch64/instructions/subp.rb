module AArch64
  module Instructions
    # SUBP -- A64
    # Subtract Pointer
    # SUBP  <Xd>, <Xn|SP>, <Xm|SP>
    class SUBP
      def initialize xd, xn, xm
        @xd = xd
        @xn = xn
        @xm = xm
      end

      def encode
        SUBP(@xm.to_i, @xn.to_i, @xm.to_i)
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
