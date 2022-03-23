module AArch64
  module Instructions
    # STUMAX, STUMAXL -- A64
    # Atomic unsigned maximum on word or doubleword in memory, without return
    # STUMAX  <Ws>, [<Xn|SP>]
    # LDUMAX <Ws>, WZR, [<Xn|SP>]
    # STUMAXL  <Ws>, [<Xn|SP>]
    # LDUMAXL <Ws>, WZR, [<Xn|SP>]
    # STUMAX  <Xs>, [<Xn|SP>]
    # LDUMAX <Xs>, XZR, [<Xn|SP>]
    # STUMAXL  <Xs>, [<Xn|SP>]
    # LDUMAXL <Xs>, XZR, [<Xn|SP>]
    class STUMAX_LDUMAX
      def encode
        raise NotImplementedError
      end

      private

      def STUMAX_LDUMAX r, rs, rn
        insn = 0b1x_111_0_00_0_0_1_00000_0_110_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
