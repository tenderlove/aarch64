module AArch64
  module Instructions
    # STGP -- A64
    # Store Allocation Tag and Pair of registers
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class STGP
      def initialize xt, xt2, xn, simm7, option
        @xt     = xt
        @xt2    = xt2
        @xn     = xn
        @simm7  = simm7
        @option = option
      end

      def encode
        STGP(@option, @simm7, @xt2.to_i, @xn.to_i, @xt.to_i)
      end

      private

      def STGP option, simm7, xt2, xn, xt
        insn = 0b0_1_101_0_000_0_0000000_00000_00000_00000
        insn |= ((option & 0x3) << 23)
        insn |= ((simm7 & 0x7f) << 15)
        insn |= ((xt2 & 0x1f) << 10)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
