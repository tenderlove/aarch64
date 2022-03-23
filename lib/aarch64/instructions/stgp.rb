module AArch64
  module Instructions
    # STGP -- A64
    # Store Allocation Tag and Pair of registers
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class STGP
      def encode
        raise NotImplementedError
      end

      private

      def STGP simm7, xt2, xn, xt
        insn = 0b0_1_101_0_001_0_0000000_00000_00000_00000
        insn |= ((simm7 & 0x7f) << 15)
        insn |= ((xt2 & 0x1f) << 10)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
