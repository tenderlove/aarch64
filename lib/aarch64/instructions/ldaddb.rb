module AArch64
  module Instructions
    # LDADDB, LDADDAB, LDADDALB, LDADDLB -- A64
    # Atomic add on byte in memory
    # LDADDAB  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDALB  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDB  <Ws>, <Wt>, [<Xn|SP>]
    # LDADDLB  <Ws>, <Wt>, [<Xn|SP>]
    class LDADDB < Instruction
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDADDB(@a, @r, @rs, @rn, @rt)
      end

      private

      def LDADDB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_0_000_00_00000_00000
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
