module AArch64
  module Instructions
    # STUMAXH, STUMAXLH -- A64
    # Atomic unsigned maximum on halfword in memory, without return
    # STUMAXH  <Ws>, [<Xn|SP>]
    # LDUMAXH <Ws>, WZR, [<Xn|SP>]
    # STUMAXLH  <Ws>, [<Xn|SP>]
    # LDUMAXLH <Ws>, WZR, [<Xn|SP>]
    class STUMAXH_LDUMAXH
      def encode
        raise NotImplementedError
      end

      private

      def STUMAXH_LDUMAXH r, rs, rn
        insn = 0b01_111_0_00_0_0_1_00000_0_110_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
