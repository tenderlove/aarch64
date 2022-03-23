module AArch64
  module Instructions
    # STSMINB, STSMINLB -- A64
    # Atomic signed minimum on byte in memory, without return
    # STSMINB  <Ws>, [<Xn|SP>]
    # LDSMINB <Ws>, WZR, [<Xn|SP>]
    # STSMINLB  <Ws>, [<Xn|SP>]
    # LDSMINLB <Ws>, WZR, [<Xn|SP>]
    class STSMINB_LDSMINB
      def encode
        raise NotImplementedError
      end

      private

      def STSMINB_LDSMINB r, rs, rn
        insn = 0b00_111_0_00_0_0_1_00000_0_101_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
