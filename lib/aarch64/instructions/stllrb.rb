module AArch64
  module Instructions
    # STLLRB -- A64
    # Store LORelease Register Byte
    # STLLRB  <Wt>, [<Xn|SP>{,#0}]
    class STLLRB < Instruction
      def initialize rt, rn
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode
        STLLRB(@rn, @rt)
      end

      private

      def STLLRB rn, rt
        insn = 0b00_001000_1_0_0_11111_0_11111_00000_00000
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
