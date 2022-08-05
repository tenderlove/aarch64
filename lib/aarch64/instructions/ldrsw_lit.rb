module AArch64
  module Instructions
    # LDRSW (literal) -- A64
    # Load Register Signed Word (literal)
    # LDRSW  <Xt>, <label>
    class LDRSW_lit < Instruction
      def initialize rt, imm19
        @rt    = check_mask(rt, 0x1f)
        @imm19 = imm19
      end

      def encode
        LDRSW_lit(check_mask(unwrap_label(@imm19), 0x7ffff), @rt)
      end

      private

      def LDRSW_lit imm19, rt
        insn = 0b10_011_0_00_0000000000000000000_00000
        insn |= (imm19 << 5)
        insn |= rt
        insn
      end
    end
  end
end
