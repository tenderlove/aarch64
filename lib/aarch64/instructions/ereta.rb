module AArch64
  module Instructions
    # ERETAA, ERETAB -- A64
    # Exception Return, with pointer authentication
    # ERETAA
    # ERETAB
    class ERETA < Instruction
      def initialize m
        @m = check_mask(m, 0x01)
      end

      def encode _
        ERETA(@m)
      end

      private

      def ERETA m
        insn = 0b1101011_0_100_11111_0000_1_0_11111_11111
        insn |= ((m) << 10)
        insn
      end
    end
  end
end
