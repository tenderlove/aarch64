module AArch64
  module Instructions
    # STUMINH, STUMINLH -- A64
    # Atomic unsigned minimum on halfword in memory, without return
    # STUMINH  <Ws>, [<Xn|SP>]
    # LDUMINH <Ws>, WZR, [<Xn|SP>]
    # STUMINLH  <Ws>, [<Xn|SP>]
    # LDUMINLH <Ws>, WZR, [<Xn|SP>]
    class STUMINH_LDUMINH
      def encode
        raise NotImplementedError
      end

      private

      def STUMINH_LDUMINH r, rs, rn
        insn = 0b01_111_0_00_0_0_1_00000_0_111_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
