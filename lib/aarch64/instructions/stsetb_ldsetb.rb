module AArch64
  module Instructions
    # STSETB, STSETLB -- A64
    # Atomic bit set on byte in memory, without return
    # STSETB  <Ws>, [<Xn|SP>]
    # LDSETB <Ws>, WZR, [<Xn|SP>]
    # STSETLB  <Ws>, [<Xn|SP>]
    # LDSETLB <Ws>, WZR, [<Xn|SP>]
    class STSETB_LDSETB
      def encode
        raise NotImplementedError
      end

      private

      def STSETB_LDSETB r, rs, rn
        insn = 0b00_111_0_00_0_0_1_00000_0_011_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
