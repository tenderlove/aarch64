module AArch64
  module Instructions
    # LDGM -- A64
    # Load Tag Multiple
    # LDGM  <Xt>, [<Xn|SP>]
    class LDGM < Instruction
      def initialize xt, xn
        @xt = xt
        @xn = xn
      end

      def encode
        LDGM(@xn.to_i, @xt.to_i)
      end

      private

      def LDGM xn, xt
        insn = 0b11011001_1_1_1_0_0_0_0_0_0_0_0_0_0_0_00000_00000
        insn |= ((apply_mask(xn, 0x1f)) << 5)
        insn |= (apply_mask(xt, 0x1f))
        insn
      end
    end
  end
end
