module AArch64
  module Instructions
    # DCPS2 -- A64
    # Debug Change PE State to EL2.
    # DCPS2  {#<imm>}
    class DCPS2
      def encode
        raise NotImplementedError
      end

      private

      def DCPS2 imm16
        insn = 0b11010100_101_0000000000000000_000_10
        insn |= ((imm16 & 0xffff) << 5)
        insn
      end
    end
  end
end
