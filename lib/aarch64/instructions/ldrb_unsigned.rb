module AArch64
  module Instructions
    # LDRB (immediate) -- A64
    # Load Register Byte (immediate)
    # LDRB  <Wt>, [<Xn|SP>{, #<pimm>}]
    class LDRB_unsigned
      def initialize rt, rn, imm12
        @rt    = rt
        @rn    = rn
        @imm12 = imm12
      end

      def encode
        self.LDRB_imm(@imm12, @rn.to_i, @rt.to_i)
      end

      private

      def LDRB_imm imm12, rn, rt
        insn = 0b00_111_0_01_01_0_00000000000_00000_00000
        insn |= ((imm12 & 0xfff) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
