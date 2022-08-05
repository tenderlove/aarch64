module AArch64
  module Instructions
    # STGP -- A64
    # Store Allocation Tag and Pair of registers
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # STGP  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class STGP < Instruction
      def initialize xt, xt2, xn, simm7, option
        @xt     = check_mask(xt, 0x1f)
        @xt2    = check_mask(xt2, 0x1f)
        @xn     = check_mask(xn, 0x1f)
        @simm7  = check_mask(simm7, 0x7f)
        @option = check_mask(option, 0x03)
      end

      def encode
        STGP(@option, @simm7, @xt2, @xn, @xt)
      end

      private

      def STGP option, simm7, xt2, xn, xt
        insn = 0b0_1_101_0_000_0_0000000_00000_00000_00000
        insn |= ((option) << 23)
        insn |= ((simm7) << 15)
        insn |= ((xt2) << 10)
        insn |= ((xn) << 5)
        insn |= (xt)
        insn
      end
    end
  end
end
