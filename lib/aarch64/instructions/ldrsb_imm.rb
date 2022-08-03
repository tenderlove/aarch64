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
    class LDRSB_imm < Instruction
      def initialize rt, rn, imm9, option, opc
        @rt     = rt
        @rn     = rn
        @imm9   = imm9
        @option = option
        @opc    = opc
      end

      def encode
        LDRSB_imm(@opc, @imm9, @option, @rn, @rt)
      end

      private

      def LDRSB_imm opc, imm9, option, rn, rt
        insn = 0b00_111_0_00_00_0_000000000_01_00000_00000
        insn |= ((apply_mask(opc, 0x3)) << 22)
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(option, 0x3)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
