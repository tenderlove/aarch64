module AArch64
  module Instructions
    # STRB (immediate) -- A64
    # Store Register Byte (immediate)
    # STRB  <Wt>, [<Xn|SP>], #<simm>
    # STRB  <Wt>, [<Xn|SP>, #<simm>]!
    # STRB  <Wt>, [<Xn|SP>{, #<pimm>}]
    class STRB_imm < Instruction
      def initialize rt, rn, imm9, opt
        @rt   = rt
        @rn   = rn
        @imm9 = imm9
        @opt  = opt
      end

      def encode
        STRB_imm(@imm9, @opt, @rn.to_i, @rt.to_i)
      end

      private

      def STRB_imm imm9, opt, rn, rt
        insn = 0b00_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(opt, 0x3)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
