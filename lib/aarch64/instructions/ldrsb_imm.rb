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
    class LDRSB_imm
      def encode
        raise NotImplementedError
      end

      private

      def LDRSB_imm imm9, rn, rt
        insn = 0b00_111_0_00_1x_0_000000000_01_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
