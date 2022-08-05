module AArch64
  module Instructions
    # LDSMINB, LDSMINAB, LDSMINALB, LDSMINLB -- A64
    # Atomic signed minimum on byte in memory
    # LDSMINAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDSMINB < Instruction
      def initialize rs, rt, rn, a, r
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @a  = check_mask(a, 0x01)
        @r  = check_mask(r, 0x01)
      end

      def encode
        LDSMINB(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDSMINB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_101_00_00000_00000
        insn |= ((apply_mask(a, 0x1)) << 23)
        insn |= ((apply_mask(r, 0x1)) << 22)
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
