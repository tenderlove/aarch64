module AArch64
  module Instructions
    # SWPH, SWPAH, SWPALH, SWPLH -- A64
    # Swap halfword in memory
    # SWPAH  <Ws>, <Wt>, [<Xn|SP>]
    # SWPALH  <Ws>, <Wt>, [<Xn|SP>]
    # SWPH  <Ws>, <Wt>, [<Xn|SP>]
    # SWPLH  <Ws>, <Wt>, [<Xn|SP>]
    class SWPH < Instruction
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        SWPH(@a, @r, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def SWPH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_1_000_00_00000_00000
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
