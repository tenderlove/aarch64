module AArch64
  module Instructions
    # LDURSW -- A64
    # Load Register Signed Word (unscaled)
    # LDURSW  <Xt>, [<Xn|SP>{, #<simm>}]
    class LDURSW < Instruction
      def initialize rt, rn, imm9
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
      end

      def encode
        LDURSW(@imm9, @rn.to_i, @rt.to_i)
      end

      private

      def LDURSW imm9, rn, rt
        insn = 0b10_111_0_00_10_0_000000000_00_00000_00000
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
