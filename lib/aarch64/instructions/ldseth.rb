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
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDSETH(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDSETH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_011_00_00000_00000
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
