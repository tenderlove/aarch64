module AArch64
  module Instructions
    # UDF -- A64
    # Permanently Undefined
    # UDF  #<imm>
    class UDF_perm_undef
      def encode
        raise NotImplementedError
      end

      private

      def UDF_perm_undef imm16
        insn = 0b0000000000000000_0000000000000000
        insn |= (imm16 & 0xffff)
        insn
      end
    end
  end
end
