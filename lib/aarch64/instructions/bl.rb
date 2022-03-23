module AArch64
  module Instructions
    # BL -- A64
    # Branch with Link
    # BL  <label>
    class BL
      def encode
        raise NotImplementedError
      end

      private

      def BL imm26
        insn = 0b1_00101_00000000000000000000000000
        insn |= (imm26 & 0x3ffffff)
        insn
      end
    end
  end
end
