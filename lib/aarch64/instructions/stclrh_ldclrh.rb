module AArch64
  module Instructions
    # STCLRH, STCLRLH -- A64
    # Atomic bit clear on halfword in memory, without return
    # STCLRH  <Ws>, [<Xn|SP>]
    # LDCLRH <Ws>, WZR, [<Xn|SP>]
    # STCLRLH  <Ws>, [<Xn|SP>]
    # LDCLRLH <Ws>, WZR, [<Xn|SP>]
    class STCLRH_LDCLRH
      def encode
        raise NotImplementedError
      end

      private

      def STCLRH_LDCLRH r, rs, rn
        insn = 0b01_111_0_00_0_0_1_00000_0_001_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
