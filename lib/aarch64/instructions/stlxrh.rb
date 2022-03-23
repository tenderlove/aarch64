module AArch64
  module Instructions
    # STLXRH -- A64
    # Store-Release Exclusive Register Halfword
    # STLXRH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class STLXRH
      def encode
        raise NotImplementedError
      end

      private

      def STLXRH rs, rn, rt
        insn = 0b01_001000_0_0_0_00000_1_11111_00000_00000
        insn |= ((rs & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
