module AArch64
  module Instructions
    # DCPS3 -- A64
    # Debug Change PE State to EL3
    # DCPS3  {#<imm>}
    class DCPS3
      def encode
        raise NotImplementedError
      end

      private

      def DCPS3 imm16
        insn = 0b11010100_101_0000000000000000_000_11
        insn |= ((imm16 & 0xffff) << 5)
        insn
      end
    end
  end
end
