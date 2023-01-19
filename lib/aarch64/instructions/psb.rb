module AArch64
  module Instructions
    # PSB CSYNC -- A64
    # Profiling Synchronization Barrier
    # PSB CSYNC
    class PSB < Instruction
      def encode _
        0b1101010100_0_00_011_0010_0010_001_11111
      end
    end
  end
end
