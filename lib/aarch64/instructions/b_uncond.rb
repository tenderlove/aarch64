module AArch64
  module Instructions
    # B -- A64
    # Branch
    # B  <label>
    class B_uncond
      def encode
        raise NotImplementedError
      end

      private

      def B_uncond imm26
        insn = 0b0_00101_00000000000000000000000000
        insn |= (imm26 & 0x3ffffff)
        insn
      end
    end
  end
end
