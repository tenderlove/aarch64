module AArch64
  module Instructions
    # LDRAA, LDRAB -- A64
    # Load Register, with pointer authentication
    # LDRAA  <Xt>, [<Xn|SP>{, #<simm>}]
    # LDRAA  <Xt>, [<Xn|SP>{, #<simm>}]!
    # LDRAB  <Xt>, [<Xn|SP>{, #<simm>}]
    # LDRAB  <Xt>, [<Xn|SP>{, #<simm>}]!
    class LDRA
      def initialize rt, rn, imm9, m, w, s
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
        @m    = m
        @w    = w
        @s    = s
      end

      def encode
        LDRA(@m, @s, @imm9, @w, @rn.to_i, @rt.to_i)
      end

      private

      def LDRA m, s, imm9, w, rn, rt
        insn = 0b11_111_0_00_0_0_1_000000000_0_1_00000_00000
        insn |= ((m & 0x1) << 23)
        insn |= ((s & 0x1) << 22)
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((w & 0x1) << 11)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
