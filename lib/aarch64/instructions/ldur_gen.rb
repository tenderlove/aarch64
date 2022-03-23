module AArch64
  module Instructions
    # LDUR -- A64
    # Load Register (unscaled)
    # LDUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDUR  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDUR_gen
      def encode
        raise NotImplementedError
      end

      private

      def LDUR_gen imm9, rn, rt
        insn = 0b1x_111_0_00_01_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
