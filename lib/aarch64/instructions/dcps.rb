module AArch64
  module Instructions
    # DCPS1 -- A64
    # Debug Change PE State to EL1.
    # DCPS1  {#<imm>}
    class DCPS
      def initialize imm, ll
        @imm = imm
        @ll  = ll
      end

      def encode
        DCPS(@imm, @ll)
      end

      private

      def DCPS imm16, ll
        insn = 0b11010100_101_0000000000000000_000_00
        insn |= ((imm16 & 0xffff) << 5)
        insn |= (ll & 0x3)
        insn
      end
    end
  end
end
