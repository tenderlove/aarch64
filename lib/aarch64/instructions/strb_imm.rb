module AArch64
  module Instructions
    # STRB (immediate) -- A64
    # Store Register Byte (immediate)
    # STRB  <Wt>, [<Xn|SP>], #<simm>
    # STRB  <Wt>, [<Xn|SP>, #<simm>]!
    # STRB  <Wt>, [<Xn|SP>{, #<pimm>}]
    class STRB_imm < Instruction
      def initialize rt, rn, imm9, opt
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @opt  = check_mask(opt, 0x03)
      end

      def encode
        STRB_imm(@imm9, @opt, @rn, @rt)
      end

      private

      def STRB_imm imm9, opt, rn, rt
        insn = 0b00_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((imm9) << 12)
        insn |= ((opt) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
