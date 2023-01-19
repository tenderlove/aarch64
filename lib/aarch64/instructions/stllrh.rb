module AArch64
  module Instructions
    # STLLRH -- A64
    # Store LORelease Register Halfword
    # STLLRH  <Wt>, [<Xn|SP>{,#0}]
    class STLLRH < Instruction
      def initialize rt, rn
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode _
        STLLRH(@rn, @rt)
      end

      private

      def STLLRH rn, rt
        insn = 0b01_001000_1_0_0_11111_0_11111_00000_00000
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
