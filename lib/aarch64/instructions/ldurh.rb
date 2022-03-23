module AArch64
  module Instructions
    # LDURH -- A64
    # Load Register Halfword (unscaled)
    # LDURH  <Wt>, [<Xn|SP>{, #<simm>}]
    class LDURH
      def encode
        raise NotImplementedError
      end

      private

      def LDURH imm9, rn, rt
        insn = 0b01_111_0_00_01_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
