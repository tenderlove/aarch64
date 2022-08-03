module AArch64
  module Instructions
    # LDAR -- A64
    # Load-Acquire Register
    # LDAR  <Wt>, [<Xn|SP>{,#0}]
    # LDAR  <Xt>, [<Xn|SP>{,#0}]
    class LDAR < Instruction
      def initialize rt, rn, size
        @rt   = rt
        @rn   = rn
        @size = size
      end

      def encode
        LDAR(@size, @rn, @rt)
      end

      private

      def LDAR size, rn, rt
        insn = 0b00_001000_1_1_0_11111_1_11111_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
