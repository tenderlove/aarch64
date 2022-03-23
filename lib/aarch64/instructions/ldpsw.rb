module AArch64
  module Instructions
    # LDPSW -- A64
    # Load Pair of Registers Signed Word
    # LDPSW  <Xt1>, <Xt2>, [<Xn|SP>], #<imm>
    # LDPSW  <Xt1>, <Xt2>, [<Xn|SP>, #<imm>]!
    # LDPSW  <Xt1>, <Xt2>, [<Xn|SP>{, #<imm>}]
    class LDPSW
      def encode
        raise NotImplementedError
      end

      private

      def LDPSW imm7, rt2, rn, rt
        insn = 0b01_101_0_001_1_0000000_00000_00000_00000
        insn |= ((imm7 & 0x7f) << 15)
        insn |= ((rt2 & 0x1f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
