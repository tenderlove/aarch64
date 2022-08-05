module AArch64
  module Instructions
    # STXRB -- A64
    # Store Exclusive Register Byte
    # STXRB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class STXRB < Instruction
      def initialize rs, rt, rn
        @rs = check_mask(rs, 0x1f)
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode
        STXRB(@rs, @rn, @rt)
      end

      private

      def STXRB rs, rn, rt
        insn = 0b00_001000_0_0_0_00000_0_11111_00000_00000
        insn |= ((rs) << 16)
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
