module AArch64
  module Instructions
    # ESB -- A64
    # Error Synchronization Barrier
    # ESB
    class ESB
      def encode
        raise NotImplementedError
      end

      private

      def ESB 
        insn = 0b1101010100_0_00_011_0010_0010_000_11111
        insn
      end
    end
  end
end
