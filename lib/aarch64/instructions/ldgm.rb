module AArch64
  module Instructions
    # LDGM -- A64
    # Load Tag Multiple
    # LDGM  <Xt>, [<Xn|SP>]
    class LDGM < Instruction
      def initialize xt, xn
        @xt = check_mask(xt, 0x1f)
        @xn = check_mask(xn, 0x1f)
      end

      def encode _
        LDGM(@xn, @xt)
      end

      private

      def LDGM xn, xt
        insn = 0b11011001_1_1_1_0_0_0_0_0_0_0_0_0_0_0_00000_00000
        insn |= ((xn) << 5)
        insn |= (xt)
        insn
      end
    end
  end
end
