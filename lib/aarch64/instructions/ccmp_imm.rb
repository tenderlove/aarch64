module AArch64
  module Instructions
    # CCMP (immediate) -- A64
    # Conditional Compare (immediate)
    # CCMP  <Wn>, #<imm>, #<nzcv>, <cond>
    # CCMP  <Xn>, #<imm>, #<nzcv>, <cond>
    class CCMP_imm < Instruction
      def initialize rn, imm, nzcv, cond, sf
        @rn   = rn
        @imm  = imm
        @nzcv = nzcv
        @cond = cond
        @sf   = sf
      end

      def encode
        CCMP_imm(@sf, @imm, @cond, @rn.to_i, @nzcv)
      end

      private

      def CCMP_imm sf, imm5, cond, rn, nzcv
        insn = 0b0_1_1_11010010_00000_0000_1_0_00000_0_0000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(imm5, 0x1f)) << 16)
        insn |= ((apply_mask(cond, 0xf)) << 12)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(nzcv, 0xf))
        insn
      end
    end
  end
end
