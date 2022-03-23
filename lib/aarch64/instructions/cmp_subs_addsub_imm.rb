module AArch64
  module Instructions
    # CMP (immediate) -- A64
    # Compare (immediate)
    # CMP  <Wn|WSP>, #<imm>{, <shift>}
    # SUBS WZR, <Wn|WSP>, #<imm> {, <shift>}
    # CMP  <Xn|SP>, #<imm>{, <shift>}
    # SUBS XZR, <Xn|SP>, #<imm> {, <shift>}
    class CMP_SUBS_addsub_imm
      def encode
        raise NotImplementedError
      end

      private

      def CMP_SUBS_addsub_imm sf, sh, imm12, rn
        insn = 0b0_1_1_100010_0_000000000000_00000_11111
        insn |= ((sf & 0x1) << 31)
        insn |= ((sh & 0x1) << 22)
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
