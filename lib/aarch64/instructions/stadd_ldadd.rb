module AArch64
  module Instructions
    # STADD, STADDL -- A64
    # Atomic add on word or doubleword in memory, without return
    # STADD  <Ws>, [<Xn|SP>]
    # LDADD <Ws>, WZR, [<Xn|SP>]
    # STADDL  <Ws>, [<Xn|SP>]
    # LDADDL <Ws>, WZR, [<Xn|SP>]
    # STADD  <Xs>, [<Xn|SP>]
    # LDADD <Xs>, XZR, [<Xn|SP>]
    # STADDL  <Xs>, [<Xn|SP>]
    # LDADDL <Xs>, XZR, [<Xn|SP>]
    class STADD_LDADD
      def encode
        raise NotImplementedError
      end

      private

      def STADD_LDADD r, rs, rn
        insn = 0b1x_111_0_00_0_0_1_00000_0_000_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
