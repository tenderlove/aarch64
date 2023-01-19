module AArch64
  module Instructions
    # LDXR -- A64
    # Load Exclusive Register
    # LDXR  <Wt>, [<Xn|SP>{,#0}]
    # LDXR  <Xt>, [<Xn|SP>{,#0}]
    class LDXR < Instruction
      def initialize rt, rn, size
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @size = check_mask(size, 0x03)
      end

      def encode _
        LDXR(@size, @rn, @rt)
      end

      private

      def LDXR size, rn, rt
        insn = 0b00_001000_0_1_0_11111_0_11111_00000_00000
        insn |= ((size) << 30)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
