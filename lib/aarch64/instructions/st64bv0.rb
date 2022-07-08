module AArch64
  module Instructions
    # ST64BV0 -- A64
    # Single-copy Atomic 64-byte EL0 Store with Return
    # ST64BV0  <Xs>, <Xt>, [<Xn|SP>]
    class ST64BV0 < Instruction
      def initialize rs, rt, rn
        @rs = rs
        @rt = rt
        @rn = rn
      end

      def encode
        ST64BV0(@rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def ST64BV0 rs, rn, rt
        insn = 0b11_111_0_00_0_0_1_00000_1_010_00_00000_00000
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
