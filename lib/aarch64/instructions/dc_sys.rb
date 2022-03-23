module AArch64
  module Instructions
    # DC -- A64
    # Data Cache operation
    # DC  <dc_op>, <Xt>
    # SYS #<op1>, C7, <Cm>, #<op2>, <Xt>
    class DC_SYS
      def encode
        raise NotImplementedError
      end

      private

      def DC_SYS op1, crm, op2, rt
        insn = 0b1101010100_0_01_000_0111_0000_000_00000
        insn |= ((op1 & 0x7) << 16)
        insn |= ((crm & 0xf) << 8)
        insn |= ((op2 & 0x7) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
