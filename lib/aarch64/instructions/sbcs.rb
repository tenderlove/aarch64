module AArch64
  module Instructions
    # SBCS -- A64
    # Subtract with Carry, setting flags
    # SBCS  <Wd>, <Wn>, <Wm>
    # SBCS  <Xd>, <Xn>, <Xm>
    class SBCS
      def initialize rd, rn, rm, sf
        @rd = rd
        @rn = rn
        @rm = rm
        @sf = sf
      end

      def encode
        self.SBCS(@sf, @rm.to_i, @rn.to_i, @rd.to_i)
      end

      private

      def SBCS sf, rm, rn, rd
        insn = 0b0_1_1_11010000_00000_000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
