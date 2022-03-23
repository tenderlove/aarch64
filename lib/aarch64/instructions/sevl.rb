module AArch64
  module Instructions
    # SEVL -- A64
    # Send Event Local
    # SEVL
    class SEVL
      def encode
        raise NotImplementedError
      end

      private

      def SEVL 
        insn = 0b1101010100_0_00_011_0010_0000_101_11111
        insn
      end
    end
  end
end
