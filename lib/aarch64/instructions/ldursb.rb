module AArch64
  module Instructions
    # LDURSB -- A64
    # Load Register Signed Byte (unscaled)
    # LDURSB  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDURSB  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDURSB < Instruction
      def initialize rt, rn, imm9, opc
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @opc  = check_mask(opc, 0x03)
      end

      def encode _
        LDURSB(@opc, @imm9, @rn, @rt)
      end

      private

      def LDURSB opc, imm9, rn, rt
        insn = 0b00_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((opc) << 22)
        insn |= ((imm9) << 12)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
