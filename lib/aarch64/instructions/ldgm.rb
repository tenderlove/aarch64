module AArch64
  module Instructions
    # LDGM -- A64
    # Load Tag Multiple
    # LDGM  <Xt>, [<Xn|SP>]
    class LDGM
      def encode
        raise NotImplementedError
      end

      private

      def LDGM xn, xt
        insn = 0b11011001_1_1_1_0_0_0_0_0_0_0_0_0_0_0_00000_00000
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
