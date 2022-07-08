module AArch64
  module Instructions
    # LDXR -- A64
    # Load Exclusive Register
    # LDXR  <Wt>, [<Xn|SP>{,#0}]
    # LDXR  <Xt>, [<Xn|SP>{,#0}]
    class LDXR < Instruction
      def initialize rt, rn, size
        @rt   = rt
        @rn   = rn
        @size = size
      end

      def encode
        LDXR(@size, @rn.to_i, @rt.to_i)
      end

      private

      def LDXR size, rn, rt
        insn = 0b00_001000_0_1_0_11111_0_11111_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
