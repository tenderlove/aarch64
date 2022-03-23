module AArch64
  module Instructions
    # STUR -- A64
    # Store Register (unscaled)
    # STUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # STUR  <Xt>, [<Xn|SP>{, #<simm>}]
    class STUR_gen
      def encode
        raise NotImplementedError
      end

      private

      def STUR_gen imm9, rn, rt
        insn = 0b1x_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
