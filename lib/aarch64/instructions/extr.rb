module AArch64
  module Instructions
    # EXTR -- A64
    # Extract register
    # EXTR  <Wd>, <Wn>, <Wm>, #<lsb>
    # EXTR  <Xd>, <Xn>, <Xm>, #<lsb>
    class EXTR < Instruction
      def initialize rd, rn, rm, lsb, sf
        @rd  = rd
        @rn  = rn
        @rm  = rm
        @lsb = lsb
        @sf  = sf
      end

      def encode
        EXTR(@sf, @sf, @rm, @lsb, @rn, @rd)
      end

      private

      def EXTR sf, n, rm, imms, rn, rd
        insn = 0b0_00_100111_0_0_00000_000000_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(n, 0x1)) << 22)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(imms, 0x3f)) << 10)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
