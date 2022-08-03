module AArch64
  module Instructions
    # LDUMINB, LDUMINAB, LDUMINALB, LDUMINLB -- A64
    # Atomic unsigned minimum on byte in memory
    # LDUMINAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINB  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDUMINB < Instruction
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDUMINB(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDUMINB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_111_00_00000_00000
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
