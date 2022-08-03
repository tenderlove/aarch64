module AArch64
  module Instructions
    # IRG -- A64
    # Insert Random Tag
    # IRG  <Xd|SP>, <Xn|SP>{, <Xm>}
    class IRG < Instruction
      def initialize rd, rn, rm
        @rd = rd
        @rn = rn
        @rm = rm
      end

      def encode
        IRG(@rm, @rn, @rd)
      end

      private

      def IRG xm, xn, xd
        insn = 0b1_0_0_11010110_00000_0_0_0_1_0_0_00000_00000
        insn |= ((apply_mask(xm, 0x1f)) << 16)
        insn |= ((apply_mask(xn, 0x1f)) << 5)
        insn |= (apply_mask(xd, 0x1f))
        insn
      end
    end
  end
end
