module AArch64
  module Instructions
    # CMN (extended register) -- A64
    # Compare Negative (extended register)
    # CMN  <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # ADDS WZR, <Wn|WSP>, <Wm>{, <extend> {#<amount>}}
    # CMN  <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    # ADDS XZR, <Xn|SP>, <R><m>{, <extend> {#<amount>}}
    class CMN_ADDS_addsub_ext
      def encode
        raise NotImplementedError
      end

      private

      def CMN_ADDS_addsub_ext sf, rm, option, imm3, rn
        insn = 0b0_0_1_01011_00_1_00000_000_000_00000_11111
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
