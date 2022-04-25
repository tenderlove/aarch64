module AArch64
  module Instructions
    # STRB (immediate) -- A64
    # Store Register Byte (immediate)
    # STRB  <Wt>, [<Xn|SP>{, #<pimm>}]
    class STRB_imm_unsigned
      def initialize rt, rn, imm12
        @rt    = rt
        @rn    = rn
        @imm12 = imm12
      end

      def encode
        self.STRB_imm_unsigned(@imm12, @rn.to_i, @rt.to_i)
      end

      private

      def STRB_imm_unsigned imm12, rn, rt
        insn = 0b00_111_0_01_00_0_000000000_00_00000_00000
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
