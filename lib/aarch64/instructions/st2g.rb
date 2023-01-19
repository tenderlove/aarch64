module AArch64
  module Instructions
    # ST2G -- A64
    # Store Allocation Tags
    # ST2G  <Xt|SP>, [<Xn|SP>], #<simm>
    # ST2G  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # ST2G  <Xt|SP>, [<Xn|SP>{, #<simm>}]
    class ST2G < Instruction
      def initialize xt, xn, imm9, option
        @xt     = check_mask(xt, 0x1f)
        @xn     = check_mask(xn, 0x1f)
        @imm9   = check_mask(imm9, 0x1ff)
        @option = check_mask(option, 0x03)
      end

      def encode _
        ST2G(@imm9, @option, @xn, @xt)
      end

      private

      def ST2G imm9, option, xn, xt
        insn = 0b11011001_1_0_1_000000000_00_00000_00000
        insn |= ((imm9) << 12)
        insn |= ((option) << 10)
        insn |= ((xn) << 5)
        insn |= (xt)
        insn
      end
    end
  end
end
