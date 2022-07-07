module AArch64
  module Instructions
    # LDURSB -- A64
    # Load Register Signed Byte (unscaled)
    # LDURSB  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDURSB  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDURSB < Instruction
      def initialize rt, rn, imm9, opc
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
        @opc  = opc
      end

      def encode
        LDURSB(@opc, @imm9, @rn.to_i, @rt.to_i)
      end

      private

      def LDURSB opc, imm9, rn, rt
        insn = 0b00_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((opc & 0x3) << 22)
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
