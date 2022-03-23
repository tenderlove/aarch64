module AArch64
  module Instructions
    # STGM -- A64
    # Store Tag Multiple
    # STGM  <Xt>, [<Xn|SP>]
    class STGM
      def encode
        raise NotImplementedError
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
