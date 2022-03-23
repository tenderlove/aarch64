module AArch64
  module Instructions
    # DCPS1 -- A64
    # Debug Change PE State to EL1.
    # DCPS1  {#<imm>}
    class DCPS1
      def encode
        raise NotImplementedError
      end

      private

      def DCPS1 imm16
        insn = 0b11010100_101_0000000000000000_000_01
        insn |= ((imm16 & 0xffff) << 5)
        insn
      end
    end
  end
end
