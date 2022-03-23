module AArch64
  module Instructions
    # NOP -- A64
    # No Operation
    # NOP
    class NOP
      def encode
        raise NotImplementedError
      end

      private

      def NOP 
        insn = 0b1101010100_0_00_011_0010_0000_000_11111
        insn
      end
    end
  end
end
