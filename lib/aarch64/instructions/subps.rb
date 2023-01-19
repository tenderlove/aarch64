module AArch64
  module Instructions
    # SUBPS -- A64
    # Subtract Pointer, setting Flags
    # SUBPS  <Xd>, <Xn|SP>, <Xm|SP>
    class SUBPS < Instruction
      def initialize xd, xn, xm
        @xd = check_mask(xd, 0x1f)
        @xn = check_mask(xn, 0x1f)
        @xm = check_mask(xm, 0x1f)
      end

      def encode _
        SUBPS(@xm, @xn, @xd)
      end

      private

      def SUBPS xm, xn, xd
        insn = 0b1_0_1_11010110_00000_0_0_0_0_0_0_00000_00000
        insn |= ((xm) << 16)
        insn |= ((xn) << 5)
        insn |= (xd)
        insn
      end
    end
  end
end
