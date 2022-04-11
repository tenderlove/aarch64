module AArch64
  module Instructions
    # LDXRH -- A64
    # Load Exclusive Register Halfword
    # LDXRH  <Wt>, [<Xn|SP>{,#0}]
    class LDXRH
      def initialize rt, rn
        @rt = rt
        @rn = rn
      end

      def encode
        self.LDXRH(@rn.to_i, @rt.to_i)
      end

      private

      def LDXRH rn, rt
        insn = 0b01_001000_0_1_0_11111_0_11111_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
