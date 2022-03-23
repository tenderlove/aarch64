module AArch64
  module Instructions
    # CMN (immediate) -- A64
    # Compare Negative (immediate)
    # CMN  <Wn|WSP>, #<imm>{, <shift>}
    # ADDS WZR, <Wn|WSP>, #<imm> {, <shift>}
    # CMN  <Xn|SP>, #<imm>{, <shift>}
    # ADDS XZR, <Xn|SP>, #<imm> {, <shift>}
    class CMN_ADDS_addsub_imm
      def encode
        raise NotImplementedError
      end

      private

      def CMN_ADDS_addsub_imm sf, sh, imm12, rn
        insn = 0b0_0_1_100010_0_000000000000_00000_11111
        insn |= ((sf & 0x1) << 31)
        insn |= ((sh & 0x1) << 22)
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
