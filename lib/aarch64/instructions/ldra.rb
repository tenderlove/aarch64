module AArch64
  module Instructions
    # LDRAA, LDRAB -- A64
    # Load Register, with pointer authentication
    # LDRAA  <Xt>, [<Xn|SP>{, #<simm>}]
    # LDRAA  <Xt>, [<Xn|SP>{, #<simm>}]!
    # LDRAB  <Xt>, [<Xn|SP>{, #<simm>}]
    # LDRAB  <Xt>, [<Xn|SP>{, #<simm>}]!
    class LDRA < Instruction
      def initialize rt, rn, imm9, m, w, s
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @m    = check_mask(m, 0x01)
        @w    = check_mask(w, 0x01)
        @s    = check_mask(s, 0x01)
      end

      def encode
        LDRA(@m, @s, @imm9, @w, @rn, @rt)
      end

      private

      def LDRA m, s, imm9, w, rn, rt
        insn = 0b11_111_0_00_0_0_1_000000000_0_1_00000_00000
        insn |= ((apply_mask(m, 0x1)) << 23)
        insn |= ((apply_mask(s, 0x1)) << 22)
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(w, 0x1)) << 11)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
