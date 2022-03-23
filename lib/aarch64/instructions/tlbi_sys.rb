module AArch64
  module Instructions
    # TLBI -- A64
    # TLB Invalidate operation
    # TLBI  <tlbi_op>{, <Xt>}
    # SYS #<op1>, C8, <Cm>, #<op2>{, <Xt>}
    class TLBI_SYS
      def encode
        raise NotImplementedError
      end

      private

      def TLBI_SYS op1, crm, op2, rt
        insn = 0b1101010100_0_01_000_1000_0000_000_00000
        insn |= ((op1 & 0x7) << 16)
        insn |= ((crm & 0xf) << 8)
        insn |= ((op2 & 0x7) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
