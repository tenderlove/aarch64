module AArch64
  module Instructions
    # CSNEG -- A64
    # Conditional Select Negation
    # CSNEG  <Wd>, <Wn>, <Wm>, <cond>
    # CSNEG  <Xd>, <Xn>, <Xm>, <cond>
    class CSNEG < Instruction
      def initialize rd, rn, rm, cond, sf
        @rd   = rd
        @rn   = rn
        @rm   = rm
        @cond = cond
        @sf   = sf
      end

      def encode
        CSNEG(@sf, @rm, @cond, @rn, @rd)
      end

      private

      def CSNEG sf, rm, cond, rn, rd
        insn = 0b0_1_0_11010100_00000_0000_0_1_00000_00000
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
