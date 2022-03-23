module AArch64
  module Instructions
    # CASH, CASAH, CASALH, CASLH -- A64
    # Compare and Swap halfword in memory
    # CASAH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASALH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASLH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class CASH
      def encode
        raise NotImplementedError
      end

      private

      def CASH l, rs, o0, rn, rt
        insn = 0b01_0010001_0_1_00000_0_11111_00000_00000
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
