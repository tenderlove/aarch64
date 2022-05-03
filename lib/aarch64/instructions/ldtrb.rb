module AArch64
  module Instructions
    # LDTRB -- A64
    # Load Register Byte (unprivileged)
    # LDTRB  <Wt>, [<Xn|SP>{, #<simm>}]
    class LDTRB
      def initialize rt, rn, imm9
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
      end

      def encode
        LDTRB(@imm9, @rn.to_i, @rt.to_i)
      end

      private

      def LDTRB imm9, rn, rt
        insn = 0b00_111_0_00_01_0_000000000_10_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
