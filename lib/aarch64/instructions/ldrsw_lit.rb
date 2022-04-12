module AArch64
  module Instructions
    # LDRSW (literal) -- A64
    # Load Register Signed Word (literal)
    # LDRSW  <Xt>, <label>
    class LDRSW_lit
      def initialize rt, imm19
        @rt    = rt
        @imm19 = imm19
      end

      def encode
        self.LDRSW_lit(@imm19.to_i / 4, @rt.to_i)
      end

      private

      def LDRSW_lit imm19, rt
        insn = 0b10_011_0_00_0000000000000000000_00000
        insn |= ((imm19 & 0x7ffff) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
