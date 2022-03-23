module AArch64
  module Instructions
    # STUMIN, STUMINL -- A64
    # Atomic unsigned minimum on word or doubleword in memory, without return
    # STUMIN  <Ws>, [<Xn|SP>]
    # LDUMIN <Ws>, WZR, [<Xn|SP>]
    # STUMINL  <Ws>, [<Xn|SP>]
    # LDUMINL <Ws>, WZR, [<Xn|SP>]
    # STUMIN  <Xs>, [<Xn|SP>]
    # LDUMIN <Xs>, XZR, [<Xn|SP>]
    # STUMINL  <Xs>, [<Xn|SP>]
    # LDUMINL <Xs>, XZR, [<Xn|SP>]
    class STUMIN_LDUMIN
      def encode
        raise NotImplementedError
      end

      private

      def STUMIN_LDUMIN r, rs, rn
        insn = 0b1x_111_0_00_0_0_1_00000_0_111_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
