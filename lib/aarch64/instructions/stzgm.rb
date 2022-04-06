module AArch64
  module Instructions
    # STZGM -- A64
    # Store Tag and Zero Multiple
    # STZGM  <Xt>, [<Xn|SP>]
    class STZGM
      def initialize rt, rn
        @rt = rt
        @rn = rn
      end

      def encode
        self.STZGM(@rn.to_i, @rt.to_i)
      end

      private

      def STZGM xn, xt
        insn = 0b11011001_0_0_1_0_0_0_0_0_0_0_0_0_0_0_00000_00000
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
