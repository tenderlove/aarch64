module AArch64
  module Instructions
    # STEOR, STEORL -- A64
    # Atomic exclusive OR on word or doubleword in memory, without return
    # STEOR  <Ws>, [<Xn|SP>]
    # LDEOR <Ws>, WZR, [<Xn|SP>]
    # STEORL  <Ws>, [<Xn|SP>]
    # LDEORL <Ws>, WZR, [<Xn|SP>]
    # STEOR  <Xs>, [<Xn|SP>]
    # LDEOR <Xs>, XZR, [<Xn|SP>]
    # STEORL  <Xs>, [<Xn|SP>]
    # LDEORL <Xs>, XZR, [<Xn|SP>]
    class STEOR_LDEOR
      def encode
        raise NotImplementedError
      end

      private

      def STEOR_LDEOR r, rs, rn
        insn = 0b1x_111_0_00_0_0_1_00000_0_010_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
