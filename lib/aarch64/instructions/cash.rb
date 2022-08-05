module AArch64
  module Instructions
    # CASH, CASAH, CASALH, CASLH -- A64
    # Compare and Swap halfword in memory
    # CASAH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASALH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    # CASLH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class CASH < Instruction
      def initialize rs, rt, rn, l, o0
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @l  = check_mask(l, 0x01)
        @o0 = check_mask(o0, 0x01)
      end

      def encode
        CASH(@l, @rs, @o0, @rn, @rt)
      end

      private

      def CASH l, rs, o0, rn, rt
        insn = 0b01_0010001_0_1_00000_0_11111_00000_00000
        insn |= ((apply_mask(l, 0x1)) << 22)
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(o0, 0x1)) << 15)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
