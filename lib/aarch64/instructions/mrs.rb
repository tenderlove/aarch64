module AArch64
  module Instructions
    # MRS -- A64
    # Move System Register
    # MRS  <Xt>, (<systemreg>|S<op0>_<op1>_<Cn>_<Cm>_<op2>)
    class MRS < Instruction
      def initialize o0, op1, crn, crm, op2, rt
        @o0  = o0
        @op1 = op1
        @crn = crn
        @crm = crm
        @op2 = op2
        @rt  = rt
      end

      def encode
        MRS(@o0, @op1, @crn, @crm, @op2, @rt.to_i)
      end

      private

      def MRS o0, op1, crn, crm, op2, rt
        insn = 0b1101010100_1_1_0_000_0000_0000_000_00000
        insn |= ((apply_mask(o0, 0x1)) << 19)
        insn |= ((apply_mask(op1, 0x7)) << 16)
        insn |= ((apply_mask(crn, 0xf)) << 12)
        insn |= ((apply_mask(crm, 0xf)) << 8)
        insn |= ((apply_mask(op2, 0x7)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
