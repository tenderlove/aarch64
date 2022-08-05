module AArch64
  module Instructions
    # CSEL -- A64
    # Conditional Select
    # CSEL  <Wd>, <Wn>, <Wm>, <cond>
    # CSEL  <Xd>, <Xn>, <Xm>, <cond>
    class CSEL < Instruction
      def initialize rd, rn, rm, cond, sf
        @rd   = check_mask(rd, 0x1f)
        @rn   = check_mask(rn, 0x1f)
        @rm   = check_mask(rm, 0x1f)
        @cond = check_mask(cond, 0x0f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode
        CSEL @sf, @rm, @cond, @rn, @rd
      end

      private

      def CSEL sf, rm, cond, rn, rd
        insn = 0b0_0_0_11010100_00000_0000_0_0_00000_00000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(cond, 0xf)) << 12)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(rd, 0x1f))
        insn
      end
    end
  end
end
