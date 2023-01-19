module AArch64
  module Instructions
    # RETAA, RETAB -- A64
    # Return from subroutine, with pointer authentication
    # RETAA
    # RETAB
    class RETA < Instruction
      def initialize m
        @m = check_mask(m, 0x01)
      end

      def encode _
        RETA(@m)
      end

      private

      def RETA m
        insn = 0b1101011_0_0_10_11111_0000_1_0_11111_11111
        insn |= ((m) << 10)
        insn
      end
    end
  end
end
