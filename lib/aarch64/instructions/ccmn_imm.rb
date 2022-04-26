module AArch64
  module Instructions
    # CCMN (immediate) -- A64
    # Conditional Compare Negative (immediate)
    # CCMN  <Wn>, #<imm>, #<nzcv>, <cond>
    # CCMN  <Xn>, #<imm>, #<nzcv>, <cond>
    class CCMN_imm
      def initialize rn, imm, nzcv, cond, sf
        @rn   = rn
        @imm  = imm
        @nzcv = nzcv
        @cond = cond
        @sf   = sf
      end

      def encode
        CCMN_imm(@sf, @imm, @cond, @rn.to_i, @nzcv)
      end

      private

      def CCMN_imm sf, imm5, cond, rn, nzcv
        insn = 0b0_0_1_11010010_00000_0000_1_0_00000_0_0000
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
