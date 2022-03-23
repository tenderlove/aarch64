module AArch64
  module Instructions
    # SWPB, SWPAB, SWPALB, SWPLB -- A64
    # Swap byte in memory
    # SWPAB  <Ws>, <Wt>, [<Xn|SP>]
    # SWPALB  <Ws>, <Wt>, [<Xn|SP>]
    # SWPB  <Ws>, <Wt>, [<Xn|SP>]
    # SWPLB  <Ws>, <Wt>, [<Xn|SP>]
    class SWPB
      def encode
        raise NotImplementedError
      end

      private

      def SWPB a, r, rs, rn, rt
        insn = 0b00_111_0_00_0_0_1_00000_1_000_00_00000_00000
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
