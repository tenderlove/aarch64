module AArch64
  module Instructions
    # AT -- A64
    # Address Translate
    # AT  <at_op>, <Xt>
    # SYS #<op1>, C7, <Cm>, #<op2>, <Xt>
    class AT_SYS
      def encode
        raise NotImplementedError
      end

      private

      def AT_SYS op1, op2, rt
        insn = 0b1101010100_0_01_000_0111_100x_000_00000
        insn |= ((op1 & 0x7) << 16)
        insn |= ((op2 & 0x7) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
