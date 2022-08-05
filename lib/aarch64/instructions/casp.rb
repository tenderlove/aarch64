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
    class CASP < Instruction
      def initialize rs, rt, rn, l, o0, sf
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @l  = check_mask(l, 0x01)
        @o0 = check_mask(o0, 0x01)
        @sf = check_mask(sf, 0x01)
      end

      def encode
        CASP(@sf, @l, @rs, @o0, @rn, @rt)
      end

      private

      def CASP sz, l, rs, o0, rn, rt
        insn = 0b0_0_001000_0_0_1_00000_0_11111_00000_00000
        insn |= ((sz) << 30)
        insn |= ((l) << 22)
        insn |= ((rs) << 16)
        insn |= ((o0) << 15)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
