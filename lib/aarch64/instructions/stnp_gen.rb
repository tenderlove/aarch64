module AArch64
  module Instructions
    # STNP -- A64
    # Store Pair of Registers, with non-temporal hint
    # STNP  <Wt1>, <Wt2>, [<Xn|SP>{, #<imm>}]
    # STNP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class STNP_gen
      def encode
        raise NotImplementedError
      end

      private

      def STNP_gen imm7, rt2, rn, rt
        insn = 0bx0_101_0_000_0_0000000_00000_00000_00000
        insn |= ((imm7 & 0x7f) << 15)
        insn |= ((rt2 & 0x1f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
