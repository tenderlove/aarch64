module AArch64
  module Instructions
    # LDURSH -- A64
    # Load Register Signed Halfword (unscaled)
    # LDURSH  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDURSH  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDURSH < Instruction
      def initialize rt, rn, imm9, opc
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @opc  = check_mask(opc, 0x03)
      end

      def encode
        LDURSH(@opc, @imm9, @rn, @rt)
      end

      private

      def LDURSH opc, imm9, rn, rt
        insn = 0b01_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((apply_mask(opc, 0x3)) << 22)
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
