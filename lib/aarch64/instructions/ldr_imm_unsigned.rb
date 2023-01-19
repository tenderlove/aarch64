module AArch64
  module Instructions
    # LDR (immediate) -- A64
    # Load Register (immediate)
    # LDR  <Wt>, [<Xn|SP>{, #<pimm>}]
    # LDR  <Xt>, [<Xn|SP>{, #<pimm>}]
    class LDR_imm_unsigned < Instruction
      def initialize rt, rn, imm12, size
        @rt    = check_mask(rt, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @imm12 = check_mask(imm12, 0xfff)
        @size  = check_mask(size, 0x03)
      end

      def encode _
        LDR_imm_gen(@size, @imm12, @rn, @rt)
      end

      private

      def LDR_imm_gen size, imm12, rn, rt
        insn = 0b00_111_0_01_01_000000000000_00000_00000
        insn |= ((size) << 30)
        insn |= ((imm12) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
