module AArch64
  module Instructions
    # STLLR -- A64
    # Store LORelease Register
    # STLLR  <Wt>, [<Xn|SP>{,#0}]
    # STLLR  <Xt>, [<Xn|SP>{,#0}]
    class STLLR < Instruction
      def initialize rt, rn, size
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
      end

      def encode
        STLLR(@size, @rn, @rt)
      end

      private

      def STLLR size, rn, rt
        insn = 0b00_001000_1_0_0_11111_0_11111_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
