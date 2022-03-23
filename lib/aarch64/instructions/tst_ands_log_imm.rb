module AArch64
  module Instructions
    # TST (immediate) -- A64
    # Test bits (immediate)
    # TST  <Wn>, #<imm>
    # ANDS WZR, <Wn>, #<imm>
    # TST  <Xn>, #<imm>
    # ANDS XZR, <Xn>, #<imm>
    class TST_ANDS_log_imm
      def encode
        raise NotImplementedError
      end

      private

      def TST_ANDS_log_imm sf, n, immr, imms, rn
        insn = 0b0_11_100100_0_000000_000000_00000_11111
        insn |= ((sf & 0x1) << 31)
        insn |= ((n & 0x1) << 22)
        insn |= ((immr & 0x3f) << 16)
        insn |= ((imms & 0x3f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn
      end
    end
  end
end
