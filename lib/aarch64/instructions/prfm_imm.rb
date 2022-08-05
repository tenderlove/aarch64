module AArch64
  module Instructions
    # PRFM (immediate) -- A64
    # Prefetch Memory (immediate)
    # PRFM  (<prfop>|#<imm5>), [<Xn|SP>{, #<pimm>}]
    class PRFM_imm < Instruction
      def initialize rt, rn, imm12
        @rt    = check_mask(rt, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @imm12 = check_mask(imm12, 0xfff)
      end

      def encode
        PRFM_imm(@imm12, @rn, @rt)
      end

      private

      def PRFM_imm imm12, rn, rt
        insn = 0b11_111_0_01_10_000000000000_00000_00000
        insn |= ((imm12) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
