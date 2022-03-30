module AArch64
  module Instructions
    # CCMN (register) -- A64
    # Conditional Compare Negative (register)
    # CCMN  <Wn>, <Wm>, #<nzcv>, <cond>
    # CCMN  <Xn>, <Xm>, #<nzcv>, <cond>
    class CCMN_reg
      def initialize rn, rm, nzcv, cond
        @rn   = rn
        @rm   = rm
        @nzcv = nzcv
        @cond = cond
      end

      def encode
        CCMN_reg(@rn.sf, @rm.to_i, Utils.cond2bin(@cond), @rn.to_i, @nzcv)
      end

      private

      def CCMN_reg sf, rm, cond, rn, nzcv
        insn = 0b0_0_1_11010010_00000_0000_0_0_00000_0_0000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((cond & 0xf) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (nzcv & 0xf)
        insn
      end
    end
  end
end
