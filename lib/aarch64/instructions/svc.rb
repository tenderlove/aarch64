module AArch64
  module Instructions
    # SVC -- A64
    # Supervisor Call
    # SVC  #<imm>
    class SVC
      def encode
        raise NotImplementedError
      end

      private

      def SVC imm16
        insn = 0b11010100_000_0000000000000000_000_01
        insn |= ((imm16 & 0xffff) << 5)
        insn
      end
    end
  end
end
