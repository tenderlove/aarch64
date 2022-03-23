module AArch64
  module Instructions
    # ST64BV -- A64
    # Single-copy Atomic 64-byte Store with Return
    # ST64BV  <Xs>, <Xt>, [<Xn|SP>]
    class ST64BV
      def encode
        raise NotImplementedError
      end

      private

      def ST64BV rs, rn, rt
        insn = 0b11_111_0_00_0_0_1_00000_1_011_00_00000_00000
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
