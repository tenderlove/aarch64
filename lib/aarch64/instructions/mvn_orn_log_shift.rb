module AArch64
  module Instructions
    # MVN -- A64
    # Bitwise NOT
    # MVN  <Wd>, <Wm>{, <shift> #<amount>}
    # ORN <Wd>, WZR, <Wm>{, <shift> #<amount>}
    # MVN  <Xd>, <Xm>{, <shift> #<amount>}
    # ORN <Xd>, XZR, <Xm>{, <shift> #<amount>}
    class MVN_ORN_log_shift
      def encode
        raise NotImplementedError
      end

      private

      def MVN_ORN_log_shift sf, shift, rm, imm6, rd
        insn = 0b0_01_01010_00_1_00000_000000_11111_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((shift & 0x3) << 22)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((imm6 & 0x3f) << 10)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
