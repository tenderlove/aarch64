module AArch64
  module Instructions
    # SYS -- A64
    # System instruction
    # SYS  #<op1>, <Cn>, <Cm>, #<op2>{, <Xt>}
    class SYS < Instruction
      def initialize op1, cn, cm, op2, xt
        @op1 = check_mask(op1, 0x07)
        @cn  = check_mask(cn, 0x0f)
        @cm  = check_mask(cm, 0x0f)
        @op2 = check_mask(op2, 0x07)
        @xt  = check_mask(xt, 0x1f)
      end

      def encode
        SYS(@op1, @cn, @cm, @op2, @xt)
      end

      private

      def SYS op1, crn, crm, op2, rt
        insn = 0b1101010100_0_01_000_0000_0000_000_00000
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
