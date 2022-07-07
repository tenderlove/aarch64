module AArch64
  module Instructions
    # STRH (immediate) -- A64
    # Store Register Halfword (immediate)
    # STRH  <Wt>, [<Xn|SP>{, #<pimm>}]
    class STRH_imm_unsigned < Instruction
      def initialize rt, rn, imm12
        @rt    = rt
        @rn    = rn
        @imm12 = imm12
      end

      def encode
        STRH_imm_unsigned(@imm12, @rn.to_i, @rt.to_i)
      end

      private

      def STRH_imm_unsigned imm12, rn, rt
        insn = 0b01_111_0_01_00_0_000000000_00_00000_00000
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
