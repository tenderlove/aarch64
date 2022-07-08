module AArch64
  module Instructions
    # STXRB -- A64
    # Store Exclusive Register Byte
    # STXRB  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class STXRB < Instruction
      def initialize rs, rt, rn
        @rs = rs
        @rt = rt
        @rn = rn
      end

      def encode
        STXRB(@rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def STXRB rs, rn, rt
        insn = 0b00_001000_0_0_0_00000_0_11111_00000_00000
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
