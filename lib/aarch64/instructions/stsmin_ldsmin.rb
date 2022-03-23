module AArch64
  module Instructions
    # STSMIN, STSMINL -- A64
    # Atomic signed minimum on word or doubleword in memory, without return
    # STSMIN  <Ws>, [<Xn|SP>]
    # LDSMIN <Ws>, WZR, [<Xn|SP>]
    # STSMINL  <Ws>, [<Xn|SP>]
    # LDSMINL <Ws>, WZR, [<Xn|SP>]
    # STSMIN  <Xs>, [<Xn|SP>]
    # LDSMIN <Xs>, XZR, [<Xn|SP>]
    # STSMINL  <Xs>, [<Xn|SP>]
    # LDSMINL <Xs>, XZR, [<Xn|SP>]
    class STSMIN_LDSMIN
      def encode
        raise NotImplementedError
      end

      private

      def STSMIN_LDSMIN r, rs, rn
        insn = 0b1x_111_0_00_0_0_1_00000_0_101_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
