module AArch64
  module Instructions
    # LDSMAXH, LDSMAXAH, LDSMAXALH, LDSMAXLH -- A64
    # Atomic signed maximum on halfword in memory
    # LDSMAXAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMAXLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDSMAXH < Instruction
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDSMAXH(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDSMAXH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_100_00_00000_00000
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
