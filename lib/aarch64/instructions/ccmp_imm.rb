module AArch64
  module Instructions
    # CCMP (immediate) -- A64
    # Conditional Compare (immediate)
    # CCMP  <Wn>, #<imm>, #<nzcv>, <cond>
    # CCMP  <Xn>, #<imm>, #<nzcv>, <cond>
    class CCMP_imm < Instruction
      def initialize rn, imm, nzcv, cond, sf
        @rn   = check_mask(rn, 0x1f)
        @imm  = check_mask(imm, 0x1f)
        @nzcv = check_mask(nzcv, 0x0f)
        @cond = check_mask(cond, 0x0f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode
        CCMP_imm(@sf, @imm, @cond, @rn, @nzcv)
      end

      private

      def CCMP_imm sf, imm5, cond, rn, nzcv
        insn = 0b0_1_1_11010010_00000_0000_1_0_00000_0_0000
        insn |= ((sf) << 31)
        insn |= ((imm5) << 16)
        insn |= ((cond) << 12)
        insn |= ((rn) << 5)
        insn |= (nzcv)
        insn
      end
    end
  end
end
