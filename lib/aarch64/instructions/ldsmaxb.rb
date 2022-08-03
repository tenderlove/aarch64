module AArch64
  module Instructions
    # LDSMAXB, LDSMAXAB, LDSMAXALB, LDSMAXLB -- A64
    # Atomic signed maximum on byte in memory
    # LDSMAXAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDSMAXB < Instruction
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDSMAXB(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDSMAXB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_100_00_00000_00000
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
