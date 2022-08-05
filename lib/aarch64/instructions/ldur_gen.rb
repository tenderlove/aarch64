module AArch64
  module Instructions
    # LDUR -- A64
    # Load Register (unscaled)
    # LDUR  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDUR  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDUR_gen < Instruction
      def initialize rt, rn, imm9, size
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @size = check_mask(size, 0x03)
      end

      def encode
        LDUR_gen(@size, @imm9, @rn, @rt)
      end

      private

      def LDUR_gen size, imm9, rn, rt
        insn = 0b00_111_0_00_01_0_000000000_00_00000_00000
        insn |= ((apply_mask(size, 0x3)) << 30)
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
