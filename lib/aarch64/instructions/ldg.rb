module AArch64
  module Instructions
    # LDG -- A64
    # Load Allocation Tag
    # LDG  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDG < Instruction
      def initialize xt, xn, imm9
        @xt   = check_mask(xt, 0x1f)
        @xn   = check_mask(xn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
      end

      def encode
        LDG(@imm9, @xn, @xt)
      end

      private

      def LDG imm9, xn, xt
        insn = 0b11011001_0_1_1_000000000_0_0_00000_00000
        insn |= ((imm9) << 12)
        insn |= ((xn) << 5)
        insn |= (xt)
        insn
      end
    end
  end
end
