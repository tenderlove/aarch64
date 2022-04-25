module AArch64
  module Instructions
    # STZG -- A64
    # Store Allocation Tag, Zeroing
    # STZG  <Xt|SP>, [<Xn|SP>], #<simm>
    # STZG  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # STZG  <Xt|SP>, [<Xn|SP>{, #<simm>}]
    class STZG
      def initialize xt, xn, imm9, opt
        @xt   = xt
        @xn   = xn
        @imm9 = imm9
        @opt  = opt
      end

      def encode
        self.STZG(@imm9, @opt, @xn.to_i, @xt.to_i)
      end

      private

      def STZG imm9, opt, xn, xt
        insn = 0b11011001_0_1_1_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((opt & 0x3) << 10)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
