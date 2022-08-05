module AArch64
  module Instructions
    # LDR (literal) -- A64
    # Load Register (literal)
    # LDR  <Wt>, <label>
    # LDR  <Xt>, <label>
    class LDR_lit_gen < Instruction
      def initialize rt, imm19, size
        @rt    = check_mask(rt, 0x1f)
        @imm19 = imm19
        @size  = check_mask(size, 0x3)
      end

      def encode
        LDR_lit_gen(@size, check_mask(unwrap_label(@imm19), 0x7ffff), @rt)
      end

      private

      def LDR_lit_gen size, imm19, rt
        insn = 0b00_011_0_00_0000000000000000000_00000
        insn |= (size << 30)
        insn |= (imm19 << 5)
        insn |= rt
        insn
      end
    end
  end
end
