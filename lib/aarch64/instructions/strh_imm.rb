module AArch64
  module Instructions
    # STRH (immediate) -- A64
    # Store Register Halfword (immediate)
    # STRH  <Wt>, [<Xn|SP>], #<simm>
    # STRH  <Wt>, [<Xn|SP>, #<simm>]!
    # STRH  <Wt>, [<Xn|SP>{, #<pimm>}]
    class STRH_imm < Instruction
      def initialize rt, rn, imm9, opt
        @rt   = check_mask(rt, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @imm9 = check_mask(imm9, 0x1ff)
        @opt  = check_mask(opt, 0x03)
      end

      def encode
        STRH_imm(@imm9, @opt, @rn, @rt)
      end

      private

      def STRH_imm imm9, opt, rn, rt
        insn = 0b01_111_0_00_00_0_000000000_00_00000_00000
        insn |= ((imm9) << 12)
        insn |= ((opt) << 10)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
