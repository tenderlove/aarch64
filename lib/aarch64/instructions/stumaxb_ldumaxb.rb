module AArch64
  module Instructions
    # STUMAXB, STUMAXLB -- A64
    # Atomic unsigned maximum on byte in memory, without return
    # STUMAXB  <Ws>, [<Xn|SP>]
    # LDUMAXB <Ws>, WZR, [<Xn|SP>]
    # STUMAXLB  <Ws>, [<Xn|SP>]
    # LDUMAXLB <Ws>, WZR, [<Xn|SP>]
    class STUMAXB_LDUMAXB
      def encode
        raise NotImplementedError
      end

      private

      def STUMAXB_LDUMAXB r, rs, rn
        insn = 0b00_111_0_00_0_0_1_00000_0_110_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
