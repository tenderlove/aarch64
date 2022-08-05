module AArch64
  module Instructions
    # LDSETH, LDSETAH, LDSETALH, LDSETLH -- A64
    # Atomic bit set on halfword in memory
    # LDSETAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDSETH < Instruction
      def initialize rs, rt, rn, a, r
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @a  = check_mask(a, 0x01)
        @r  = check_mask(r, 0x01)
      end

      def encode
        LDSETH(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDSETH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_011_00_00000_00000
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
