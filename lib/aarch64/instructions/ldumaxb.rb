module AArch64
  module Instructions
    # LDUMAXB, LDUMAXAB, LDUMAXALB, LDUMAXLB -- A64
    # Atomic unsigned maximum on byte in memory
    # LDUMAXAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDUMAXB < Instruction
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDUMAXB(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDUMAXB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_110_00_00000_00000
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
