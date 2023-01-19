module AArch64
  module Instructions
    # STR (immediate) -- A64
    # Store Register (immediate)
    # STR  <Wt>, [<Xn|SP>{, #<pimm>}]
    # STR  <Xt>, [<Xn|SP>{, #<pimm>}]
    class STR_imm_unsigned < Instruction
      def initialize rt, rn, imm12, size
        @rt    = check_mask(rt, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @imm12 = check_mask(imm12, 0xfff)
        @size  = check_mask(size, 0x03)
      end

      def encode _
        STR_imm_gen(@size, @imm12, @rn, @rt)
      end

      private

      def STR_imm_gen size, imm12, rn, rt
        insn = 0b00_111_0_01_00_0_000000000_00_00000_00000
        insn |= ((size) << 30)
        insn |= ((imm12) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
