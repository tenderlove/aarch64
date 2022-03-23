module AArch64
  module Instructions
    # LDR (literal) -- A64
    # Load Register (literal)
    # LDR  <Wt>, <label>
    # LDR  <Xt>, <label>
    class LDR_lit_gen
      def encode
        raise NotImplementedError
      end

      private

      def LDR_lit_gen imm19, rt
        insn = 0b0x_011_0_00_0000000000000000000_00000
        insn |= ((imm19 & 0x7ffff) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
