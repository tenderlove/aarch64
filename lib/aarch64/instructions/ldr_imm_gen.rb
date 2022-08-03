module AArch64
  module Instructions
    # LDR (immediate) -- A64
    # Load Register (immediate)
    # LDR  <Wt>, [<Xn|SP>], #<simm>
    # LDR  <Xt>, [<Xn|SP>], #<simm>
    # LDR  <Wt>, [<Xn|SP>, #<simm>]!
    # LDR  <Xt>, [<Xn|SP>, #<simm>]!
    class LDR_imm_gen < Instruction
      def initialize rt, rn, imm9, size, mode
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
        @size = size
        @mode = mode
      end

      def encode
        LDR_imm_gen(@size, @imm9, @mode, @rn, @rt)
      end

      private

      def LDR_imm_gen size, imm9, mode, rn, rt
        insn = 0b00_111_0_00_01_0_000000000_00_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(mode, 0x3)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
