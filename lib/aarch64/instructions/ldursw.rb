module AArch64
  module Instructions
    # LDURSW -- A64
    # Load Register Signed Word (unscaled)
    # LDURSW  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDURSW
      def encode
        raise NotImplementedError
      end

      private

      def LDURSW imm9, rn, rt
        insn = 0b10_111_0_00_10_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
