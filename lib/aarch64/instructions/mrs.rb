module AArch64
  module Instructions
    # MRS -- A64
    # Move System Register
    # MRS  <Xt>, (<systemreg>|S<op0>_<op1>_<Cn>_<Cm>_<op2>)
    class MRS
      def encode
        raise NotImplementedError
      end

      private

      def MRS o0, op1, crn, crm, op2, rt
        insn = 0b1101010100_1_1_0_000_0000_0000_000_00000
        insn |= ((o0 & 0x1) << 19)
        insn |= ((op1 & 0x7) << 16)
        insn |= ((crn & 0xf) << 12)
        insn |= ((crm & 0xf) << 8)
        insn |= ((op2 & 0x7) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
