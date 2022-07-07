module AArch64
  module Instructions
    # LDTRSH -- A64
    # Load Register Signed Halfword (unprivileged)
    # LDTRSH  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDTRSH  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDTRSH < Instruction
      def initialize rt, rn, imm9, opc
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
        @opc  = opc
      end

      def encode
        LDTRSH(@opc, @imm9, @rn.to_i, @rt.to_i)
      end

      private

      def LDTRSH opc, imm9, rn, rt
        insn = 0b01_111_0_00_00_0_000000000_10_00000_00000
        insn |= ((opc & 0x3) << 22)
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
