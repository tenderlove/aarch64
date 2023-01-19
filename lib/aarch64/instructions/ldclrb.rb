module AArch64
  module Instructions
    # LDCLRB, LDCLRAB, LDCLRALB, LDCLRLB -- A64
    # Atomic bit clear on byte in memory
    # LDCLRAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRB  <Ws>, <Wt>, [<Xn|SP>]
    # LDCLRLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDCLRB < Instruction
      def initialize rs, rt, rn, a, r, size
        @rs   = check_mask(rs, 0x1f)
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @a    = check_mask(a, 0x01)
        @r    = check_mask(r, 0x01)
        @size = check_mask(size, 0x03)
      end

      def encode _
        LDCLRB(@size, @a, @r, @rs, @rn, @rt)
      end

      private

      def LDCLRB size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_001_00_00000_00000
        insn |= ((size) << 30)
        insn |= ((a) << 23)
        insn |= ((r) << 22)
        insn |= ((rs) << 16)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
