module AArch64
  module Instructions
    # ST64BV0 -- A64
    # Single-copy Atomic 64-byte EL0 Store with Return
    # ST64BV0  <Xs>, <Xt>, [<Xn|SP>]
    class ST64BV0
      def encode
        raise NotImplementedError
      end

      private

      def ST64BV0 rs, rn, rt
        insn = 0b11_111_0_00_0_0_1_00000_1_010_00_00000_00000
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
