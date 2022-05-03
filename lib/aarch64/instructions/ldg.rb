module AArch64
  module Instructions
    # LDG -- A64
    # Load Allocation Tag
    # LDG  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDG
      def initialize xt, xn, imm9
        @xt   = xt
        @xn   = xn
        @imm9 = imm9
      end

      def encode
        LDG(@imm9, @xn.to_i, @xt.to_i)
      end

      private

      def LDG imm9, xn, xt
        insn = 0b11011001_0_1_1_000000000_0_0_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
