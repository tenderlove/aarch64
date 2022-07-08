module AArch64
  module Instructions
    # LDUMAXH, LDUMAXAH, LDUMAXALH, LDUMAXLH -- A64
    # Atomic unsigned maximum on halfword in memory
    # LDUMAXAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDUMAXH < Instruction
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDUMAXH(@a, @r.to_i, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDUMAXH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_110_00_00000_00000
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
