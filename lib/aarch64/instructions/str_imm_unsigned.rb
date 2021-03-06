module AArch64
  module Instructions
    # STR (immediate) -- A64
    # Store Register (immediate)
    # STR  <Wt>, [<Xn|SP>{, #<pimm>}]
    # STR  <Xt>, [<Xn|SP>{, #<pimm>}]
    class STR_imm_unsigned
      def initialize rt, rn, imm12, size
        @rt    = rt
        @rn    = rn
        @imm12 = imm12
        @size  = size
      end

      def encode
        STR_imm_gen(@size, @imm12, @rn.to_i, @rt.to_i)
      end

      private

      def STR_imm_gen size, imm12, rn, rt
        insn = 0b00_111_0_01_00_0_000000000_00_00000_00000
        insn |= ((size & 0x3) << 30)
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
