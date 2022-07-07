module AArch64
  module Instructions
    # WFE -- A64
    # Wait For Event
    # WFE
    class WFE < Instruction
      def encode
        WFE()
      end

      private

      def WFE
        insn = 0b1101010100_0_00_011_0010_0000_010_11111
        insn
      end
    end
  end
end
