module AArch64
  module Instructions
    # NEG (shifted register) -- A64
    # Negate (shifted register)
    # NEG  <Wd>, <Wm>{, <shift> #<amount>}
    # SUB  <Wd>, WZR, <Wm> {, <shift> #<amount>}
    # NEG  <Xd>, <Xm>{, <shift> #<amount>}
    # SUB  <Xd>, XZR, <Xm> {, <shift> #<amount>}
    class NEG_SUB_addsub_shift
      def encode
        raise NotImplementedError
      end

      private

      def NEG_SUB_addsub_shift sf, shift, rm, imm6, rd
        insn = 0b0_1_0_01011_00_0_00000_000000_11111_00000
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
