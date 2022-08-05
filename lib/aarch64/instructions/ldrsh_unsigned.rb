module AArch64
  module Instructions
    # LDRSH (immediate) -- A64
    # Load Register Signed Halfword (immediate)
    # LDRSH  <Wt>, [<Xn|SP>{, #<pimm>}]
    # LDRSH  <Xt>, [<Xn|SP>{, #<pimm>}]
    class LDRSH_unsigned < Instruction
      def initialize rt, rn, imm12, opc
        @rt    = check_mask(rt, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @imm12 = check_mask(imm12, 0xfff)
        @opc   = check_mask(opc, 0x03)
      end

      def encode
        LDRSH_unsigned(@opc, @imm12, @rn, @rt)
      end

      private

      def LDRSH_unsigned opc, imm12, rn, rt
        insn = 0b01_111_0_01_00_0_00000000000_00000_00000
        insn |= ((opc) << 22)
        insn |= ((imm12) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
