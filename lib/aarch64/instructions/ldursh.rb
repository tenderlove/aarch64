module AArch64
  module Instructions
    # LDURSH -- A64
    # Load Register Signed Halfword (unscaled)
    # LDURSH  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDURSH  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDURSH
      def encode
        raise NotImplementedError
      end

      private

      def LDURSH imm9, rn, rt
        insn = 0b01_111_0_00_1x_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
