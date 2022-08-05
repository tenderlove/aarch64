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
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @a  = check_mask(a, 0x01)
        @r  = check_mask(r, 0x01)
      end

      def encode
        SWPH(@a, @r, @rs, @rn, @rt)
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
