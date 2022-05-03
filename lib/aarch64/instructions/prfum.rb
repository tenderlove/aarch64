module AArch64
  module Instructions
    # PRFUM -- A64
    # Prefetch Memory (unscaled offset)
    # PRFUM (<prfop>|#<imm5>), [<Xn|SP>{, #<simm>}]
    class PRFUM
      def initialize rt, rn, imm9
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
      end

      def encode
        PRFUM(@imm9, @rn.to_i, @rt.to_i)
      end

      private

      def PRFUM imm9, rn, rt
        insn = 0b11_111_0_00_10_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
