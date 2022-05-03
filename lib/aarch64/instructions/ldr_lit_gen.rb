module AArch64
  module Instructions
    # LDR (literal) -- A64
    # Load Register (literal)
    # LDR  <Wt>, <label>
    # LDR  <Xt>, <label>
    class LDR_lit_gen
      def initialize rt, imm19, size
        @rt    = rt
        @imm19 = imm19
        @size  = size
      end

      def encode
        LDR_lit_gen(@size, @imm19.to_i / 4, @rt.to_i)
      end

      private

      def LDR_lit_gen size, imm19, rt
        insn = 0b00_011_0_00_0000000000000000000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((imm19 & 0x7ffff) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
