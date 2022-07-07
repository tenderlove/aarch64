module AArch64
  module Instructions
    # LDRH (immediate) -- A64
    # Load Register Halfword (immediate)
    # LDRH  <Wt>, [<Xn|SP>{, #<pimm>}]
    class LDRH_unsigned < Instruction
      def initialize rt, rn, imm12
        @rt    = rt
        @rn    = rn
        @imm12 = imm12
      end

      def encode
        LDRH_unsigned(@imm12, @rn.to_i, @rt.to_i)
      end

      private

      def LDRH_unsigned imm12, rn, rt
        insn = 0b01_111_0_01_01_0_00000000000_00000_00000
        insn |= ((imm12 & 0xfff) << 9)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
