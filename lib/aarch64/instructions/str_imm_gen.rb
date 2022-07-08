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
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
        @opt  = opt
        @size = size
      end

      def encode
        STR_imm_gen(@size, @imm9, @opt, @rn.to_i, @rt.to_i)
      end

      private

      def STR_imm_gen size, imm9, opt, rn, rt
        insn = 0b00_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(opt, 0x3)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
