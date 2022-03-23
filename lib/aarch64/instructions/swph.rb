module AArch64
  module Instructions
    # SWPH, SWPAH, SWPALH, SWPLH -- A64
    # Swap halfword in memory
    # SWPAH  <Ws>, <Wt>, [<Xn|SP>]
    # SWPALH  <Ws>, <Wt>, [<Xn|SP>]
    # SWPH  <Ws>, <Wt>, [<Xn|SP>]
    # SWPLH  <Ws>, <Wt>, [<Xn|SP>]
    class SWPH
      def encode
        raise NotImplementedError
      end

      private

      def SWPH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_1_000_00_00000_00000
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
