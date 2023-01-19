module AArch64
  module Instructions
    # STR (immediate) -- A64
    # Store Register (immediate)
    # STR  <Wt>, [<Xn|SP>], #<simm>
    # STR  <Xt>, [<Xn|SP>], #<simm>
    # STR  <Wt>, [<Xn|SP>, #<simm>]!
    # STR  <Xt>, [<Xn|SP>, #<simm>]!
    # STR  <Wt>, [<Xn|SP>{, #<pimm>}]
    # STR  <Xt>, [<Xn|SP>{, #<pimm>}]
    class STR_imm_gen < Instruction
      def initialize rt, rn, imm9, opt, size
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @opt  = check_mask(opt, 0x03)
        @size = check_mask(size, 0x03)
      end

      def encode _
        STR_imm_gen(@size, @imm9, @opt, @rn, @rt)
      end

      private

      def STR_imm_gen size, imm9, opt, rn, rt
        insn = 0b00_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((size) << 30)
        insn |= ((imm9) << 12)
        insn |= ((opt) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
