module AArch64
  module Instructions
    # STADDH, STADDLH -- A64
    # Atomic add on halfword in memory, without return
    # STADDH  <Ws>, [<Xn|SP>]
    # LDADDH <Ws>, WZR, [<Xn|SP>]
    # STADDLH  <Ws>, [<Xn|SP>]
    # LDADDLH <Ws>, WZR, [<Xn|SP>]
    class STADDH_LDADDH
      def encode
        raise NotImplementedError
      end

      private

      def STADDH_LDADDH r, rs, rn
        insn = 0b01_111_0_00_0_0_1_00000_0_000_00_00000_11111
        insn |= ((r & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
