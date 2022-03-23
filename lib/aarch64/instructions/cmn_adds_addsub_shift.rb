module AArch64
  module Instructions
    # CMN (shifted register) -- A64
    # Compare Negative (shifted register)
    # CMN  <Wn>, <Wm>{, <shift> #<amount>}
    # ADDS WZR, <Wn>, <Wm> {, <shift> #<amount>}
    # CMN  <Xn>, <Xm>{, <shift> #<amount>}
    # ADDS XZR, <Xn>, <Xm> {, <shift> #<amount>}
    class CMN_ADDS_addsub_shift
      def encode
        raise NotImplementedError
      end

      private

      def CMN_ADDS_addsub_shift sf, shift, rm, imm6, rn
        insn = 0b0_0_1_01011_00_0_00000_000000_00000_11111
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
