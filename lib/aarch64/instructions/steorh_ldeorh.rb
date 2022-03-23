module AArch64
  module Instructions
    # STEORH, STEORLH -- A64
    # Atomic exclusive OR on halfword in memory, without return
    # STEORH  <Ws>, [<Xn|SP>]
    # LDEORH <Ws>, WZR, [<Xn|SP>]
    # STEORLH  <Ws>, [<Xn|SP>]
    # LDEORLH <Ws>, WZR, [<Xn|SP>]
    class STEORH_LDEORH
      def encode
        raise NotImplementedError
      end

      private

      def STEORH_LDEORH r, rs, rn
        insn = 0b01_111_0_00_0_0_1_00000_0_010_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
