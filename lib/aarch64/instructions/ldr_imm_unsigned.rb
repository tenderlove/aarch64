module AArch64
  module Instructions
    # LDR (immediate) -- A64
    # Load Register (immediate)
    # LDR  <Wt>, [<Xn|SP>{, #<pimm>}]
    # LDR  <Xt>, [<Xn|SP>{, #<pimm>}]
    class LDR_imm_unsigned
      def initialize rt, rn, imm12, size
        @rt    = rt
        @rn    = rn
        @imm12 = imm12
        @size  = size
      end

      def encode
        LDR_imm_gen(@size, @imm12, @rn.to_i, @rt.to_i)
      end

      private

      def LDR_imm_gen size, imm12, rn, rt
        insn = 0b00_111_0_01_01_000000000000_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
