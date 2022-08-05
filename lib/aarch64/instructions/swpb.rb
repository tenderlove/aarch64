module AArch64
  module Instructions
    # SWPB, SWPAB, SWPALB, SWPLB -- A64
    # Swap byte in memory
    # SWPAB  <Ws>, <Wt>, [<Xn|SP>]
    # SWPALB  <Ws>, <Wt>, [<Xn|SP>]
    # SWPB  <Ws>, <Wt>, [<Xn|SP>]
    # SWPLB  <Ws>, <Wt>, [<Xn|SP>]
    class SWPB < Instruction
      def initialize rs, rt, rn, a, r
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @a  = check_mask(a, 0x01)
        @r  = check_mask(r, 0x01)
      end

      def encode
        SWPB(@a, @r, @rs, @rn, @rt)
      end

      private

      def SWPB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_1_000_00_00000_00000
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
