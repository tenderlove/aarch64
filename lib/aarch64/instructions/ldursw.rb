module AArch64
  module Instructions
    # LDURSW -- A64
    # Load Register Signed Word (unscaled)
    # LDURSW  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDURSW < Instruction
      def initialize rt, rn, imm9
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
      end

      def encode
        LDURSW(@imm9, @rn, @rt)
      end

      private

      def LDURSW imm9, rn, rt
        insn = 0b10_111_0_00_10_0_000000000_00_00000_00000
        insn |= ((imm9) << 12)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
