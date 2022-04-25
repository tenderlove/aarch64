module AArch64
  module Instructions
    # STUR -- A64
    # Store Register (unscaled)
    # STUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # STUR  <Xt>, [<Xn|SP>{, #<simm>}]
    class STUR_gen
      def initialize rt, rn, imm9, size
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
        @size = size
      end

      def encode
        self.STUR_gen(@size, @imm9, @rn.to_i, @rt.to_i)
      end

      private

      def STUR_gen size, imm9, rn, rt
        insn = 0b00_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
