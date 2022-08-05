module AArch64
  module Instructions
    # LD64B -- A64
    # Single-copy Atomic 64-byte Load
    # LD64B  <Xt>, [<Xn|SP> {,#0}]
    class LD64B < Instruction
      def initialize rt, rn
        @rt = check_mask(rt, 0x1f)
        @rn = check_mask(rn, 0x1f)
      end

      def encode
        LD64B(@rn, @rt)
      end

      private

      def LD64B rn, rt
        insn = 0b11_111_0_00_0_0_1_11111_1_101_00_00000_00000
        insn |= ((rn) << 5)
        insn |= (rt)
        insn
      end
    end
  end
end
