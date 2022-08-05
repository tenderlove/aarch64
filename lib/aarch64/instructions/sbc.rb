module AArch64
  module Instructions
    # SBC -- A64
    # Subtract with Carry
    # SBC  <Wd>, <Wn>, <Wm>
    # SBC  <Xd>, <Xn>, <Xm>
    class SBC < Instruction
      def initialize rd, rn, rm, sf
        @rd = check_mask(rd, 0x1f)
        @rn = check_mask(rn, 0x1f)
        @rm = check_mask(rm, 0x1f)
        @sf = check_mask(sf, 0x01)
      end

      def encode
        SBC(@sf, @rm, @rn, @rd)
      end

      private

      def SBC sf, rm, rn, rd
        insn = 0b0_1_0_11010000_00000_000000_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
