module AArch64
  module Instructions
    # SUBP -- A64
    # Subtract Pointer
    # SUBP  <Xd>, <Xn|SP>, <Xm|SP>
    class SUBP < Instruction
      def initialize xd, xn, xm
        @xd = check_mask(xd, 0x1f)
        @xn = check_mask(xn, 0x1f)
        @xm = check_mask(xm, 0x1f)
      end

      def encode
        SUBP(@xm, @xn, @xd)
      end

      private

      def SUBP xm, xn, xd
        insn = 0b1_0_0_11010110_00000_0_0_0_0_0_0_00000_00000
        insn |= ((apply_mask(xm, 0x1f)) << 16)
        insn |= ((apply_mask(xn, 0x1f)) << 5)
        insn |= (apply_mask(xd, 0x1f))
        insn
      end
    end
  end
end
