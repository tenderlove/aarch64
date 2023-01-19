module AArch64
  module Instructions
    # LDSMINH, LDSMINAH, LDSMINALH, LDSMINLH -- A64
    # Atomic signed minimum on halfword in memory
    # LDSMINAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDSMINH < Instruction
      def initialize rs, rt, rn, a, r
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @a  = check_mask(a, 0x01)
        @r  = check_mask(r, 0x01)
      end

      def encode _
        LDSMINH(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDSMINH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_101_00_00000_00000
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
