module AArch64
  module Instructions
    # STSMAXB, STSMAXLB -- A64
    # Atomic signed maximum on byte in memory, without return
    # STSMAXB  <Ws>, [<Xn|SP>]
    # LDSMAXB <Ws>, WZR, [<Xn|SP>]
    # STSMAXLB  <Ws>, [<Xn|SP>]
    # LDSMAXLB <Ws>, WZR, [<Xn|SP>]
    class STSMAXB_LDSMAXB
      def encode
        raise NotImplementedError
      end

      private

      def STSMAXB_LDSMAXB r, rs, rn
        insn = 0b00_111_0_00_0_0_1_00000_0_100_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
