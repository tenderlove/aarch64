module AArch64
  module Instructions
    # LDEORH, LDEORAH, LDEORALH, LDEORLH -- A64
    # Atomic exclusive OR on halfword in memory
    # LDEORAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORH  <Ws>, <Wt>, [<Xn|SP>]
    # LDEORLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDEORH
      def encode
        raise NotImplementedError
      end

      private

      def LDEORH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_010_00_00000_00000
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
