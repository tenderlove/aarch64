module AArch64
  module Instructions
    # STEORB, STEORLB -- A64
    # Atomic exclusive OR on byte in memory, without return
    # STEORB  <Ws>, [<Xn|SP>]
    # LDEORB <Ws>, WZR, [<Xn|SP>]
    # STEORLB  <Ws>, [<Xn|SP>]
    # LDEORLB <Ws>, WZR, [<Xn|SP>]
    class STEORB_LDEORB
      def encode
        raise NotImplementedError
      end

      private

      def STEORB_LDEORB r, rs, rn
        insn = 0b00_111_0_00_0_0_1_00000_0_010_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
