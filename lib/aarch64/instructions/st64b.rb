module AArch64
  module Instructions
    # ST64B -- A64
    # Single-copy Atomic 64-byte Store without Return
    # ST64B  <Xt>, [<Xn|SP> {,#0}]
    class ST64B < Instruction
      def initialize rt, rn
        @rt = rt
        @rn = rn
      end

      def encode
        ST64B(@rn.to_i, @rt.to_i)
      end

      private

      def ST64B rn, rt
        insn = 0b11_111_0_00_0_0_1_11111_1_001_00_00000_00000
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
