module AArch64
  module Instructions
    # STXRH -- A64
    # Store Exclusive Register Halfword
    # STXRH  <Ws>, <Wt>, [<Xn|SP>{,#0}]
    class STXRH < Instruction
      def initialize rs, rt, rn
        @rs = rs
        @rt = rt
        @rn = rn
      end

      def encode
        STXRH(@rs.to_i, @rn.to_i, @rt.to_i)
      end

      private

      def STXRH rs, rn, rt
        insn = 0b01_001000_0_0_0_00000_0_11111_00000_00000
        insn |= ((apply_mask(rs, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
