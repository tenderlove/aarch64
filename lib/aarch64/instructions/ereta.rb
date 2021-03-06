module AArch64
  module Instructions
    # ERETAA, ERETAB -- A64
    # Exception Return, with pointer authentication
    # ERETAA
    # ERETAB
    class ERETA
      def initialize m
        @m = m
      end

      def encode
        ERETA(@m)
      end

      private

      def ERETA m
        insn = 0b1101011_0_100_11111_0000_1_0_11111_11111
        insn |= ((m & 0x1) << 10)
        insn
      end
    end
  end
end
