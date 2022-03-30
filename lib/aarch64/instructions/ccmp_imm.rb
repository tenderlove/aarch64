module AArch64
  module Instructions
    # CCMP (immediate) -- A64
    # Conditional Compare (immediate)
    # CCMP  <Wn>, #<imm>, #<nzcv>, <cond>
    # CCMP  <Xn>, #<imm>, #<nzcv>, <cond>
    class CCMP_imm
      def initialize rn, imm, nzcv, cond
        @rn   = rn
        @imm  = imm
        @nzcv = nzcv
        @cond = cond
      end

      def encode
        CCMP_imm(@rn.sf, @imm, Utils.cond2bin(@cond), @rn.to_i, @nzcv)
      end

      private

      def CCMP_imm sf, imm5, cond, rn, nzcv
        insn = 0b0_1_1_11010010_00000_0000_1_0_00000_0_0000
        insn |= ((sf & 0x1) << 31)
        insn |= ((imm5 & 0x1f) << 16)
        insn |= ((cond & 0xf) << 12)
        insn |= ((rn & 0x1f) << 5)
        insn |= (nzcv & 0xf)
        insn
      end
    end
  end
end
