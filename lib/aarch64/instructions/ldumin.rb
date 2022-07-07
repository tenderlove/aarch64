module AArch64
  module Instructions
    # LDUMIN, LDUMINA, LDUMINAL, LDUMINL -- A64
    # Atomic unsigned minimum on word or doubleword in memory
    # LDUMIN  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINA  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINAL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMINL  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMIN  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMINA  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMINAL  <Xs>, <Xt>, [<Xn|SP>]
    # LDUMINL  <Xs>, <Xt>, [<Xn|SP>]
    class LDUMIN < Instruction
      def initialize rs, rt, rn, size, a, r
        @rs   = rs
        @rt   = rt
        @rn   = rn
        @size = size
        @a    = a
        @r    = r
      end

      def encode
        LDUMIN(@size, @a, @r.to_i, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDUMIN size, a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_111_00_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((a & 0x1) << 23)
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
