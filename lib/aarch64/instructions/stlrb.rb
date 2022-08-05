module AArch64
  module Instructions
    # STLRB -- A64
    # Store-Release Register Byte
    # STLRB  <Wt>, [<Xn|SP>{,#0}]
    class STLRB < Instruction
      def initialize rt, rn
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode
        STLRB(@rn, @rt)
      end

      private

      def STLRB rn, rt
        insn = 0b00_001000_1_0_0_11111_1_11111_00000_00000
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
