module AArch64
  module Instructions
    # UDIV -- A64
    # Unsigned Divide
    # UDIV  <Wd>, <Wn>, <Wm>
    # UDIV  <Xd>, <Xn>, <Xm>
    class UDIV < Instruction
      def initialize rd, rn, rm, sf
        @rd = rd
        @rn = rn
        @rm = rm
        @sf = sf
      end

      def encode
        UDIV(@sf, @rm.to_i, @rn.to_i, @rd.to_i)
      end

      private

      def UDIV sf, rm, rn, rd
        insn = 0b0_0_0_11010110_00000_00001_0_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
