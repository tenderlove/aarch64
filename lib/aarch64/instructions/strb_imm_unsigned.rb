module AArch64
  module Instructions
    # STRB (immediate) -- A64
    # Store Register Byte (immediate)
    # STRB  <Wt>, [<Xn|SP>{, #<pimm>}]
    class STRB_imm_unsigned < Instruction
      def initialize rt, rn, imm12
        @rt    = check_mask(rt, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @imm12 = check_mask(imm12, 0xfff)
      end

      def encode
        STRB_imm_unsigned(@imm12, @rn, @rt)
      end

      private

      def STRB_imm_unsigned imm12, rn, rt
        insn = 0b00_111_0_01_00_0_000000000_00_00000_00000
        insn |= ((imm12) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
