module AArch64
  module Instructions
    # CSINC -- A64
    # Conditional Select Increment
    # CSINC  <Wd>, <Wn>, <Wm>, <cond>
    # CSINC  <Xd>, <Xn>, <Xm>, <cond>
    class CSINC
      def initialize rd, rn, rm, cond
        @rd   = rd
        @rn   = rn
        @rm   = rm
        @cond = cond
      end

      def encode
        cond = Utils.cond2bin(@cond)
        cond ^= 1 if @rm == @rn
        CSINC(@rd.sf, @rm.to_i, cond, @rn.to_i, @rd.to_i)
      end

      private

      def CSINC sf, rm, cond, rn, rd
        insn = 0b0_0_0_11010100_00000_0000_0_1_00000_00000
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
