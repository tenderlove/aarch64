module AArch64
  module Instructions
    # NEGS -- A64
    # Negate, setting flags
    # NEGS  <Wd>, <Wm>{, <shift> #<amount>}
    # SUBS <Wd>, WZR, <Wm> {, <shift> #<amount>}
    # NEGS  <Xd>, <Xm>{, <shift> #<amount>}
    # SUBS <Xd>, XZR, <Xm> {, <shift> #<amount>}
    class NEGS_SUBS_addsub_shift
      def encode
        raise NotImplementedError
      end

      private

      def NEGS_SUBS_addsub_shift sf, shift, rm, imm6
        insn = 0b0_1_1_01011_00_0_00000_000000_11111_!= 11111
        insn |= ((sf & 0x1) << 31)
        insn |= ((shift & 0x3) << 22)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((imm6 & 0x3f) << 10)
        insn
      end
    end
  end
end
