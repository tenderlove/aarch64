module AArch64
  module Instructions
    # CSNEG -- A64
    # Conditional Select Negation
    # CSNEG  <Wd>, <Wn>, <Wm>, <cond>
    # CSNEG  <Xd>, <Xn>, <Xm>, <cond>
    class CSNEG
      def initialize rd, rn, rm, cond, sf
        @rd   = rd
        @rn   = rn
        @rm   = rm
        @cond = cond
        @sf   = sf
      end

      def encode
        CSNEG(@sf, @rm.to_i, @cond, @rn.to_i, @rd.to_i)
      end

      private

      def CSNEG sf, rm, cond, rn, rd
        insn = 0b0_1_0_11010100_00000_0000_0_1_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((cond & 0xf) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
