module AArch64
  module Instructions
    # MRS -- A64
    # Move System Register
    # MRS  <Xt>, (<systemreg>|S<op0>_<op1>_<Cn>_<Cm>_<op2>)
    class MRS < Instruction
      def initialize o0, op1, crn, crm, op2, rt
        @o0  = check_mask(o0, 0x01)
        @op1 = check_mask(op1, 0x07)
        @crn = check_mask(crn, 0x0f)
        @crm = check_mask(crm, 0x0f)
        @op2 = check_mask(op2, 0x07)
        @rt  = check_mask(rt, 0x1f)
      end

      def encode
        MRS(@o0, @op1, @crn, @crm, @op2, @rt)
      end

      private

      def MRS o0, op1, crn, crm, op2, rt
        insn = 0b1101010100_1_1_0_000_0000_0000_000_00000
        insn |= ((o0) << 19)
        insn |= ((op1) << 16)
        insn |= ((crn) << 12)
        insn |= ((crm) << 8)
        insn |= ((op2) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
