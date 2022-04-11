module AArch64
  module Instructions
    # LDXRB -- A64
    # Load Exclusive Register Byte
    # LDXRB  <Wt>, [<Xn|SP>{,#0}]
    class LDXRB
      def initialize rt, rn
        @rt = rt
        @rn = rn
      end

      def encode
        self.LDXRB(@rn.to_i, @rt.to_i)
      end

      private

      def LDXRB rn, rt
        insn = 0b00_001000_0_1_0_11111_0_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
