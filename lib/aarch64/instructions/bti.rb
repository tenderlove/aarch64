module AArch64
  module Instructions
    # BTI -- A64
    # Branch Target Identification
    # BTI  {<targets>}
    class BTI
      def encode
        raise NotImplementedError
      end

      private

      def BTI 
        insn = 0b1101010100_0_00_011_0010_0100_xx0_11111
        insn
      end
    end
  end
end
