module AArch64
  module Instructions
    # STSET, STSETL -- A64
    # Atomic bit set on word or doubleword in memory, without return
    # STSET  <Ws>, [<Xn|SP>]
    # LDSET <Ws>, WZR, [<Xn|SP>]
    # STSETL  <Ws>, [<Xn|SP>]
    # LDSETL <Ws>, WZR, [<Xn|SP>]
    # STSET  <Xs>, [<Xn|SP>]
    # LDSET <Xs>, XZR, [<Xn|SP>]
    # STSETL  <Xs>, [<Xn|SP>]
    # LDSETL <Xs>, XZR, [<Xn|SP>]
    class STSET_LDSET
      def encode
        raise NotImplementedError
      end

      private

      def STSET_LDSET r, rs, rn
        insn = 0b1x_111_0_00_0_0_1_00000_0_011_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
