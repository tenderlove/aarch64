module AArch64
  module Instructions
    # CASP, CASPA, CASPAL, CASPL -- A64
    # Compare and Swap Pair of words or doublewords in memory
    # CASP  <Ws>, <W(s+1)>, <Wt>, <W(t+1)>, [<Xn|SP>{,#0}]
    # CASPA  <Ws>, <W(s+1)>, <Wt>, <W(t+1)>, [<Xn|SP>{,#0}]
    # CASPAL  <Ws>, <W(s+1)>, <Wt>, <W(t+1)>, [<Xn|SP>{,#0}]
    # CASPL  <Ws>, <W(s+1)>, <Wt>, <W(t+1)>, [<Xn|SP>{,#0}]
    # CASP  <Xs>, <X(s+1)>, <Xt>, <X(t+1)>, [<Xn|SP>{,#0}]
    # CASPA  <Xs>, <X(s+1)>, <Xt>, <X(t+1)>, [<Xn|SP>{,#0}]
    # CASPAL  <Xs>, <X(s+1)>, <Xt>, <X(t+1)>, [<Xn|SP>{,#0}]
    # CASPL  <Xs>, <X(s+1)>, <Xt>, <X(t+1)>, [<Xn|SP>{,#0}]
    class CASP
      def encode
        raise NotImplementedError
      end

      private

      def CASP sz, l, rs, o0, rn, rt
        insn = 0b0_0_001000_0_0_1_00000_0_11111_00000_00000
        insn |= ((sz & 0x1) << 30)
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
