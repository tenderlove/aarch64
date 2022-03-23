module AArch64
  module Instructions
    # LDUMAXH, LDUMAXAH, LDUMAXALH, LDUMAXLH -- A64
    # Atomic unsigned maximum on halfword in memory
    # LDUMAXAH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXALH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXH  <Ws>, <Wt>, [<Xn|SP>]
    # LDUMAXLH  <Ws>, <Wt>, [<Xn|SP>]
    class LDUMAXH
      def encode
        raise NotImplementedError
      end

      private

      def LDUMAXH a, r, rs, rn, rt
        insn = 0b01_111_0_00_0_0_1_00000_0_110_00_00000_00000
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
