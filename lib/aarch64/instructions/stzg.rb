module AArch64
  module Instructions
    # STZG -- A64
    # Store Allocation Tag, Zeroing
    # STZG  <Xt|SP>, [<Xn|SP>], #<simm>
    # STZG  <Xt|SP>, [<Xn|SP>, #<simm>]!
    # STZG  <Xt|SP>, [<Xn|SP>{, #<simm>}]
    class STZG
      def encode
        raise NotImplementedError
      end

      private

      def STZG imm9, xn, xt
        insn = 0b11011001_0_1_1_000000000_0_1_00000_00000
        insn |= ((imm9 & 0x1ff) << 12)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xt & 0x1f)
        insn
      end
    end
  end
end
