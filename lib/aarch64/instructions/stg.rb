module AArch64
  module Instructions
    # STG -- A64
    # Store Allocation Tag
    # STG  <Xt|SP>, [<Xn|SP>], #<simm>
    # STG  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # STG  <Xt|SP>, [<Xn|SP>{, #<simm>}]
    class STG < Instruction
      def initialize xt, xn, imm9, option
        @xt     = xt
        @xn     = xn
        @imm9   = imm9
        @option = option
      end

      def encode
        STG(@imm9, @option, @xn.to_i, @xt.to_i)
      end

      private

      def STG imm9, option, xn, xt
        insn = 0b11011001_0_0_1_000000000_00_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((option & 0x3) << 10)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
