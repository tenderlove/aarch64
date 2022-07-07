module AArch64
  module Instructions
    # LDSMINH, LDSMINAH, LDSMINALH, LDSMINLH -- A64
    # Atomic signed minimum on halfword in memory
    # LDSMINAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINH  <Ws>, <Wt>, [<Xn|SP>]
    # LDSMINLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDSMINH < Instruction
      def initialize rs, rt, rn, a, r
        @rs = rs
        @rt = rt
        @rn = rn
        @a  = a
        @r  = r
      end

      def encode
        LDSMINH(@a, @r.to_i, @rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def LDSMINH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_101_00_00000_00000
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
