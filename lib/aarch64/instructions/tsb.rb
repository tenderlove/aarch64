module AArch64
  module Instructions
    # TSB CSYNC -- A64
    # Trace Synchronization Barrier
    # TSB CSYNC
    class TSB
      def encode
        raise NotImplementedError
      end

      private

      def TSB 
        insn = 0b1101010100_0_00_011_0010_0010_010_11111
        insn
      end
    end
  end
end
