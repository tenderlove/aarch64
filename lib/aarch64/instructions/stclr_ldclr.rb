module AArch64
  module Instructions
    # STCLR, STCLRL -- A64
    # Atomic bit clear on word or doubleword in memory, without return
    # STCLR  <Ws>, [<Xn|SP>]
    # LDCLR <Ws>, WZR, [<Xn|SP>]
    # STCLRL  <Ws>, [<Xn|SP>]
    # LDCLRL <Ws>, WZR, [<Xn|SP>]
    # STCLR  <Xs>, [<Xn|SP>]
    # LDCLR <Xs>, XZR, [<Xn|SP>]
    # STCLRL  <Xs>, [<Xn|SP>]
    # LDCLRL <Xs>, XZR, [<Xn|SP>]
    class STCLR_LDCLR
      def encode
        raise NotImplementedError
      end

      private

      def STCLR_LDCLR r, rs, rn
        insn = 0b1x_111_0_00_0_0_1_00000_0_001_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
