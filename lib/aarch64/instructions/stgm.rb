module AArch64
  module Instructions
    # STGM -- A64
    # Store Tag Multiple
    # STGM  <Xt>, [<Xn|SP>]
    class STGM < Instruction
      def initialize xt, xn
        @xt = check_mask(xt, 0x1f)
        @xn = check_mask(xn, 0x1f)
      end

      def encode
        STGM(@xn, @xt)
      end

      private

      def STGM xn, xt
        insn = 0b11011001_1_0_1_0_0_0_0_0_0_0_0_0_0_0_00000_00000
        insn |= ((xn) << 5)
        insn |= (xt)
        insn
      end
    end
  end
end
