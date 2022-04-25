module AArch64
  module Instructions
    # STLRH -- A64
    # Store-Release Register Halfword
    # STLRH  <Wt>, [<Xn|SP>{,#0}]
    class STLRH
      def initialize rt, rn
        @rt = rt
        @rn = rn
      end

      def encode
        self.STLRH(@rn.to_i, @rt.to_i)
      end

      private

      def STLRH rn, rt
        insn = 0b01_001000_1_0_0_11111_1_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
