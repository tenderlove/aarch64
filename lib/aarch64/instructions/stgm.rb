module AArch64
  module Instructions
    # STGM -- A64
    # Store Tag Multiple
    # STGM  <Xt>, [<Xn|SP>]
    class STGM < Instruction
      def initialize xt, xn
        @xt = xt
        @xn = xn
      end

      def encode
        STGM(@xn.to_i, @xt.to_i)
      end

      private

      def STGM xn, xt
        insn = 0b11011001_1_0_1_0_0_0_0_0_0_0_0_0_0_0_00000_00000
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
