module AArch64
  module Instructions
    # MADD -- A64
    # Multiply-Add
    # MADD  <Wd>, <Wn>, <Wm>, <Wa>
    # MADD  <Xd>, <Xn>, <Xm>, <Xa>
    class MADD < Instruction
      def initialize rd, rn, rm, ra, sf
        @rd = rd
        @rn = rn
        @rm = rm
        @ra = ra
        @sf = sf
      end

      def encode
        MADD(@sf, @rm, @ra, @rn, @rd)
      end

      private

      def MADD sf, rm, ra, rn, rd
        insn = 0b0_00_11011_000_00000_0_00000_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(ra, 0x1f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
