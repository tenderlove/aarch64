module AArch64
  module Instructions
    # STLLRH -- A64
    # Store LORelease Register Halfword
    # STLLRH  <Wt>, [<Xn|SP>{,#0}]
    class STLLRH
      def initialize rt, rn
        @rt = rt
        @rn = rn
      end

      def encode
        STLLRH(@rn.to_i, @rt.to_i)
      end

      private

      def STLLRH rn, rt
        insn = 0b01_001000_1_0_0_11111_0_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
