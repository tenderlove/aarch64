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
        @s  = s
        @t  = t
        @n  = n
        @l  = l
        @o0 = o0
        @sf = sf
      end

      def encode
        CAS(@sf, @l, @s.to_i, @o0, @n.to_i, @t.to_i)
      end

      private

      def CAS x, l, rs, o0, rn, rt
        insn = 0b10_0010001_0_1_00000_0_11111_00000_00000
        insn |= ((x & 0x1) << 30)
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
