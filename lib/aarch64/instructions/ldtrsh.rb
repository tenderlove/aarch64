module AArch64
  module Instructions
    # LDTRSH -- A64
    # Load Register Signed Halfword (unprivileged)
    # LDTRSH  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDTRSH  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDTRSH < Instruction
      def initialize rt, rn, imm9, opc
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @opc  = check_mask(opc, 0x03)
      end

      def encode
        LDTRSH(@opc, @imm9, @rn, @rt)
      end

      private

      def LDTRSH opc, imm9, rn, rt
        insn = 0b01_111_0_00_00_0_000000000_10_00000_00000
        insn |= ((apply_mask(opc, 0x3)) << 22)
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
