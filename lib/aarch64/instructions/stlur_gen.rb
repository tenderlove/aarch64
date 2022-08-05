module AArch64
  module Instructions
    # STLUR -- A64
    # Store-Release Register (unscaled)
    # STLUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # STLUR  <Xt>, [<Xn|SP>{, #<simm>}]
    class STLUR_gen < Instruction
      def initialize rt, rn, imm9, size
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @size = check_mask(size, 0x03)
      end

      def encode
        STLUR_gen(@size, @imm9, @rn, @rt)
      end

      private

      def STLUR_gen size, imm9, rn, rt
        insn = 0b00_011001_00_0_000000000_00_00000_00000
        insn |= ((size) << 30)
        insn |= ((imm9) << 12)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
