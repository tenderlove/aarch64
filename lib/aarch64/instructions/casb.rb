module AArch64
  module Instructions
    # CASB, CASAB, CASALB, CASLB -- A64
    # Compare and Swap byte in memory
    # CASAB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASALB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASLB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class CASB
      def encode
        raise NotImplementedError
      end

      private

      def CASB l, rs, o0, rn, rt
        insn = 0b00_0010001_0_1_00000_0_11111_00000_00000
        insn |= ((l & 0x1) << 22)
        insn |= ((rs & 0x1f) << 16)
        insn |= ((o0 & 0x1) << 15)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
