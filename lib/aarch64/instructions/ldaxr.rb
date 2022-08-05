module AArch64
  module Instructions
    # LDAXR -- A64
    # Load-Acquire Exclusive Register
    # LDAXR  <Wt>, [<Xn|SP>{,#0}]
    # LDAXR  <Xt>, [<Xn|SP>{,#0}]
    class LDAXR < Instruction
      def initialize rt, rn, size
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
      end

      def encode
        LDAXR(@size, @rn, @rt)
      end

      private

      def LDAXR size, rn, rt
        insn = 0b00_001000_0_1_0_11111_1_11111_00000_00000
        insn |= ((size) << 30)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
