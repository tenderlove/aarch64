module AArch64
  module Instructions
    # STLUR -- A64
    # Store-Release Register (unscaled)
    # STLUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # STLUR  <Xt>, [<Xn|SP>{, #<simm>}]
    class STLUR_gen
      def encode
        raise NotImplementedError
      end

      private

      def STLUR_gen imm9, rn, rt
        insn = 0b1x_011001_00_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
