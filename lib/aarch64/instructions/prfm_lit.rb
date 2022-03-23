module AArch64
  module Instructions
    # PRFM (literal) -- A64
    # Prefetch Memory (literal)
    # PRFM  (<prfop>|#<imm5>), <label>
    class PRFM_lit
      def encode
        raise NotImplementedError
      end

      private

      def PRFM_lit imm19, rt
        insn = 0b11_011_0_00_0000000000000000000_00000
        insn |= ((imm19 & 0x7ffff) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
