module AArch64
  module Instructions
    # LDURSB -- A64
    # Load Register Signed Byte (unscaled)
    # LDURSB  <Wt>, [<Xn|SP>{, #<simm>}]
    # LDURSB  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDURSB
      def encode
        raise NotImplementedError
      end

      private

      def LDURSB imm9, rn, rt
        insn = 0b00_111_0_00_1x_0_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
