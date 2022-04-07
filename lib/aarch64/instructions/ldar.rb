module AArch64
  module Instructions
    # LDAR -- A64
    # Load-Acquire Register
    # LDAR  <Wt>, [<Xn|SP>{,#0}]
    # LDAR  <Xt>, [<Xn|SP>{,#0}]
    class LDAR
      def initialize rt, rn, size
        @rt   = rt
        @rn   = rn
        @size = size
      end

      def encode
        self.LDAR @size, @rn.to_i, @rt.to_i
      end

      private

      def LDAR size, rn, rt
        insn = 0b00_001000_1_1_0_11111_1_11111_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
