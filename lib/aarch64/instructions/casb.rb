module AArch64
  module Instructions
    # CASB, CASAB, CASALB, CASLB -- A64
    # Compare and Swap byte in memory
    # CASAB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASALB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASLB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class CASB < Instruction
      def initialize rs, rt, rn, l, o0
        @rs = rs
        @rt = rt
        @rn = rn
        @l  = l
        @o0 = o0
      end

      def encode
        CASB(@l, @rs.to_i, @o0, @rn.to_i, @rt.to_i)
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
