module AArch64
  module Instructions
    # STRH (immediate) -- A64
    # Store Register Halfword (immediate)
    # STRH  <Wt>, [<Xn|SP>{, #<pimm>}]
    class STRH_imm_unsigned < Instruction
      def initialize rt, rn, imm12
        @rt    = check_mask(rt, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @imm12 = check_mask(imm12, 0xfff)
      end

      def encode _
        STRH_imm_unsigned(@imm12, @rn, @rt)
      end

      private

      def STRH_imm_unsigned imm12, rn, rt
        insn = 0b01_111_0_01_00_0_000000000_00_00000_00000
        insn |= ((imm12) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
