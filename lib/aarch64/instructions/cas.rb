module AArch64
  module Instructions
    # CAS, CASA, CASAL, CASL -- A64
    # Compare and Swap word or doubleword in memory
    # CAS  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASA  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASAL  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASL  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CAS  <Xs>, <Xt>, [<Xn|SP>{,#0}]
    # CASA  <Xs>, <Xt>, [<Xn|SP>{,#0}]
    # CASAL  <Xs>, <Xt>, [<Xn|SP>{,#0}]
    # CASL  <Xs>, <Xt>, [<Xn|SP>{,#0}]
    class CAS < Instruction
      def initialize s, t, n, l, o0, sf
        @s  = check_mask(s, 0x1f)
        @t  = check_mask(t, 0x1f)
        @n  = check_mask(n, 0x1f)
        @l  = check_mask(l, 0x01)
        @o0 = check_mask(o0, 0x01)
        @sf = check_mask(sf, 0x01)
      end

      def encode
        CAS(@sf, @l, @s, @o0, @n, @t)
      end

      private

      def CAS x, l, rs, o0, rn, rt
        insn = 0b10_0010001_0_1_00000_0_11111_00000_00000
        insn |= ((x) << 30)
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
