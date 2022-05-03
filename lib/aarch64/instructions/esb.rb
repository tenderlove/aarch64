module AArch64
  module Instructions
    # ESB -- A64
    # Error Synchronization Barrier
    # ESB
    class ESB
      def encode
        0b1101010100_0_00_011_0010_0010_000_11111
      end
    end
  end
end
