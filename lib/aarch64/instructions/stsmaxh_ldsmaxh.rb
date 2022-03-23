module AArch64
  module Instructions
    # STSMAXH, STSMAXLH -- A64
    # Atomic signed maximum on halfword in memory, without return
    # STSMAXH  <Ws>, [<Xn|SP>]
    # LDSMAXH <Ws>, WZR, [<Xn|SP>]
    # STSMAXLH  <Ws>, [<Xn|SP>]
    # LDSMAXLH <Ws>, WZR, [<Xn|SP>]
    class STSMAXH_LDSMAXH
      def encode
        raise NotImplementedError
      end

      private

      def STSMAXH_LDSMAXH r, rs, rn
        insn = 0b01_111_0_00_0_0_1_00000_0_100_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
