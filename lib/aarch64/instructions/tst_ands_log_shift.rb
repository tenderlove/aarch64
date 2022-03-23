module AArch64
  module Instructions
    # TST (shifted register) -- A64
    # Test (shifted register)
    # TST  <Wn>, <Wm>{, <shift> #<amount>}
    # ANDS WZR, <Wn>, <Wm>{, <shift> #<amount>}
    # TST  <Xn>, <Xm>{, <shift> #<amount>}
    # ANDS XZR, <Xn>, <Xm>{, <shift> #<amount>}
    class TST_ANDS_log_shift
      def encode
        raise NotImplementedError
      end

      private

      def TST_ANDS_log_shift sf, shift, rm, imm6, rn
        insn = 0b0_11_01010_00_0_00000_000000_00000_11111
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
