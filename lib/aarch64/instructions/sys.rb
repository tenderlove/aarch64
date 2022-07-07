module AArch64
  module Instructions
    # SYS -- A64
    # System instruction
    # SYS  #<op1>, <Cn>, <Cm>, #<op2>{, <Xt>}
    class SYS < Instruction
      def initialize op1, cn, cm, op2, xt
        @op1 = op1
        @cn  = cn
        @cm  = cm
        @op2 = op2
        @xt  = xt
      end

      def encode
        SYS(@op1, @cn, @cm, @op2, @xt.to_i)
      end

      private

      def SYS op1, crn, crm, op2, rt
        insn = 0b1101010100_0_01_000_0000_0000_000_00000
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
