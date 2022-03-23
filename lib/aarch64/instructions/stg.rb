module AArch64
  module Instructions
    # STG -- A64
    # Store Allocation Tag
    # STG  <Xt|SP>, [<Xn|SP>], #<simm>
    # STG  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # STG  <Xt|SP>, [<Xn|SP>{, #<simm>}]
    class STG
      def encode
        raise NotImplementedError
      end

      private

      def STG imm9, xn, xt
        insn = 0b11011001_0_0_1_000000000_0_1_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
