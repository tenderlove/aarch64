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
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @size = check_mask(size, 0x03)
        @mode = check_mask(mode, 0x03)
      end

      def encode
        LDR_imm_gen(@size, @imm9, @mode, @rn, @rt)
      end

      private

      def LDR_imm_gen size, imm9, mode, rn, rt
        insn = 0b00_111_0_00_01_0_000000000_00_00000_00000
        insn |= ((size) << 30)
        insn |= ((imm9) << 12)
        insn |= ((mode) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
