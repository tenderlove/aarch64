module AArch64
  module Instructions
    # STUMINB, STUMINLB -- A64
    # Atomic unsigned minimum on byte in memory, without return
    # STUMINB  <Ws>, [<Xn|SP>]
    # LDUMINB <Ws>, WZR, [<Xn|SP>]
    # STUMINLB  <Ws>, [<Xn|SP>]
    # LDUMINLB <Ws>, WZR, [<Xn|SP>]
    class STUMINB_LDUMINB
      def encode
        raise NotImplementedError
      end

      private

      def STUMINB_LDUMINB r, rs, rn
        insn = 0b00_111_0_00_0_0_1_00000_0_111_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
