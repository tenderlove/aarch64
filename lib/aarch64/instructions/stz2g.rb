module AArch64
  module Instructions
    # STZ2G -- A64
    # Store Allocation Tags, Zeroing
    # STZ2G  <Xt|SP>, [<Xn|SP>], #<simm>
    # STZ2G  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # STZ2G  <Xt|SP>, [<Xn|SP>{, #<simm>}]
    class STZ2G
      def encode
        raise NotImplementedError
      end

      private

      def STZ2G imm9, xn, xt
        insn = 0b11011001_1_1_1_000000000_0_1_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
