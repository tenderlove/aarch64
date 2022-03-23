module AArch64
  module Instructions
    # CMP (extended register) -- A64
    # Compare (extended register)
    # CMP  <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # SUBS WZR, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # CMP  <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    # SUBS XZR, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class CMP_SUBS_addsub_ext
      def encode
        raise NotImplementedError
      end

      private

      def CMP_SUBS_addsub_ext sf, rm, option, imm3, rn
        insn = 0b0_1_1_01011_00_1_00000_000_000_00000_11111
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((option & 0x7) << 13)
        insn |= ((imm3 & 0x7) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
