module AArch64
  module Instructions
    # CMP (shifted register) -- A64
    # Compare (shifted register)
    # CMP  <Wn>, <Wm>{, <shift> #<amount>}
    # SUBS WZR, <Wn>, <Wm> {, <shift> #<amount>}
    # CMP  <Xn>, <Xm>{, <shift> #<amount>}
    # SUBS XZR, <Xn>, <Xm> {, <shift> #<amount>}
    class CMP_SUBS_addsub_shift
      def encode
        raise NotImplementedError
      end

      private

      def CMP_SUBS_addsub_shift sf, shift, rm, imm6, rn
        insn = 0b0_1_1_01011_00_0_00000_000000_00000_11111
        insn |= ((sf & 0x1) << 31)
        insn |= ((shift & 0x3) << 22)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((imm6 & 0x3f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
