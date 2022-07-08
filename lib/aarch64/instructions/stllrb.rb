module AArch64
  module Instructions
    # STLLRB -- A64
    # Store LORelease Register Byte
    # STLLRB  <Wt>, [<Xn|SP>{,#0}]
    class STLLRB < Instruction
      def initialize rt, rn
        @rt = rt
        @rn = rn
      end

      def encode
        STLLRB(@rn.to_i, @rt.to_i)
      end

      private

      def STLLRB rn, rt
        insn = 0b00_001000_1_0_0_11111_0_11111_00000_00000
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
