module AArch64
  module Instructions
    # STZG -- A64
    # Store Allocation Tag, Zeroing
    # STZG  <Xt|SP>, [<Xn|SP>], #<simm>
    # STZG  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # STZG  <Xt|SP>, [<Xn|SP>{, #<simm>}]
    class STZG < Instruction
      def initialize xt, xn, imm9, opt
        @xt   = xt
        @xn   = xn
        @imm9 = imm9
        @opt  = opt
      end

      def encode
        STZG(@imm9, @opt, @xn, @xt)
      end

      private

      def STZG imm9, opt, xn, xt
        insn = 0b11011001_0_1_1_000000000_00_00000_00000
        insn |= ((apply_mask(imm9, 0x1ff)) << 12)
        insn |= ((apply_mask(opt, 0x3)) << 10)
        insn |= ((apply_mask(xn, 0x1f)) << 5)
        insn |= (apply_mask(xt, 0x1f))
        insn
      end
    end
  end
end
