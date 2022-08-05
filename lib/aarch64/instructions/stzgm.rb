module AArch64
  module Instructions
    # STZGM -- A64
    # Store Tag and Zero Multiple
    # STZGM  <Xt>, [<Xn|SP>]
    class STZGM < Instruction
      def initialize rt, rn
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode
        STZGM(@rn, @rt)
      end

      private

      def STZGM xn, xt
        insn = 0b11011001_0_0_1_0_0_0_0_0_0_0_0_0_0_0_00000_00000
        insn |= ((apply_mask(xn, 0x1f)) << 5)
        insn |= (apply_mask(xt, 0x1f))
        insn
      end
    end
  end
end
