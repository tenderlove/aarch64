module AArch64
  module Instructions
    # LD64B -- A64
    # Single-copy Atomic 64-byte Load
    # LD64B  <Xt>, [<Xn|SP> {,#0}]
    class LD64B
      def initialize rt, rn
        @rt = rt
        @rn = rn
      end

      def encode
        self.LD64B(@rn.to_i, @rt.to_i)
      end

      private

      def LD64B rn, rt
        insn = 0b11_111_0_00_0_0_1_11111_1_101_00_00000_00000
        insn |= ((rn & 0x1f) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
