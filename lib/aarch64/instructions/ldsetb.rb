module AArch64
  module Instructions
    # LDSETB, LDSETAB, LDSETALB, LDSETLB -- A64
    # Atomic bit set on byte in memory
    # LDSETAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETB  <Ws>, <Wt>, [<Xn|SP>]
    # LDSETLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDSETB
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDSETB(@a, @r.to_i, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDSETB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_011_00_00000_00000
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
