module AArch64
  module Instructions
    # LDTR -- A64
    # Load Register (unprivileged)
    # LDTR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDTR  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDTR
      def initialize rt, rn, imm9, size
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
        @size = size
      end

      def encode
        self.LDTR(@size, @imm9, @rn.to_i, @rt.to_i)
      end

      private

      def LDTR size, imm9, rn, rt
        insn = 0b00_111_0_00_01_0_000000000_10_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
