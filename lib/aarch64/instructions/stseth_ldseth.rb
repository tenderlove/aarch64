module AArch64
  module Instructions
    # STSETH, STSETLH -- A64
    # Atomic bit set on halfword in memory, without return
    # STSETH  <Ws>, [<Xn|SP>]
    # LDSETH <Ws>, WZR, [<Xn|SP>]
    # STSETLH  <Ws>, [<Xn|SP>]
    # LDSETLH <Ws>, WZR, [<Xn|SP>]
    class STSETH_LDSETH
      def encode
        raise NotImplementedError
      end

      private

      def STSETH_LDSETH r, rs, rn
        insn = 0b01_111_0_00_0_0_1_00000_0_011_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
