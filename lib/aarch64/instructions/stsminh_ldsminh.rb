module AArch64
  module Instructions
    # STSMINH, STSMINLH -- A64
    # Atomic signed minimum on halfword in memory, without return
    # STSMINH  <Ws>, [<Xn|SP>]
    # LDSMINH <Ws>, WZR, [<Xn|SP>]
    # STSMINLH  <Ws>, [<Xn|SP>]
    # LDSMINLH <Ws>, WZR, [<Xn|SP>]
    class STSMINH_LDSMINH
      def encode
        raise NotImplementedError
      end

      private

      def STSMINH_LDSMINH r, rs, rn
        insn = 0b01_111_0_00_0_0_1_00000_0_101_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
