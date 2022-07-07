module AArch64
  module Instructions
    # PSB CSYNC -- A64
    # Profiling Synchronization Barrier
    # PSB CSYNC
    class PSB < Instruction
      def encode
        PSB()
      end

      private

      def PSB
        insn = 0b1101010100_0_00_011_0010_0010_001_11111
        insn
      end
    end
  end
end
