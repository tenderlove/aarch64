module AArch64
  module Instructions
    # LDRB (immediate) -- A64
    # Load Register Byte (immediate)
    # LDRB  <Wt>, [<Xn|SP>{, #<pimm>}]
    class LDRB_unsigned < Instruction
      def initialize rt, rn, imm12
        @rt    = check_mask(rt, 0x1f)
        @rn    = check_mask(rn, 0x1f)
        @imm12 = check_mask(imm12, 0xfff)
      end

      def encode
        LDRB_imm(@imm12, @rn, @rt)
      end

      private

      def LDRB_imm imm12, rn, rt
        insn = 0b00_111_0_01_01_0_00000000000_00000_00000
        insn |= ((imm12) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
