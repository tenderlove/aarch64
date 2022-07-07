module AArch64
  module Instructions
    # LDRSB (immediate) -- A64
    # Load Register Signed Byte (immediate)
    # LDRSB  <Wt>, [<Xn|SP>], #<simm>
    # LDRSB  <Xt>, [<Xn|SP>], #<simm>
    # LDRSB  <Wt>, [<Xn|SP>, #<simm>]!
    # LDRSB  <Xt>, [<Xn|SP>, #<simm>]!
    # LDRSB  <Wt>, [<Xn|SP>{, #<pimm>}]
    # LDRSB  <Xt>, [<Xn|SP>{, #<pimm>}]
    class LDRSB_unsigned < Instruction
      def initialize rt, rn, imm12, opc
        @rt    = rt
        @rn    = rn
        @imm12 = imm12
        @opc   = opc
      end

      def encode
        LDRSB_unsigned(@opc, @imm12, @rn.to_i, @rt.to_i)
      end

      private

      def LDRSB_unsigned opc, imm12, rn, rt
        insn = 0b00_111_0_01_00_0_00000000000_00000_00000
        insn |= ((opc & 0x3) << 22)
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
