module AArch64
  module Instructions
    # STSMAX, STSMAXL -- A64
    # Atomic signed maximum on word or doubleword in memory, without return
    # STSMAX  <Ws>, [<Xn|SP>]
    # LDSMAX <Ws>, WZR, [<Xn|SP>]
    # STSMAXL  <Ws>, [<Xn|SP>]
    # LDSMAXL <Ws>, WZR, [<Xn|SP>]
    # STSMAX  <Xs>, [<Xn|SP>]
    # LDSMAX <Xs>, XZR, [<Xn|SP>]
    # STSMAXL  <Xs>, [<Xn|SP>]
    # LDSMAXL <Xs>, XZR, [<Xn|SP>]
    class STSMAX_LDSMAX
      def encode
        raise NotImplementedError
      end

      private

      def STSMAX_LDSMAX r, rs, rn
        insn = 0b1x_111_0_00_0_0_1_00000_0_100_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
