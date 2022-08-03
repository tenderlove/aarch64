module AArch64
  module Instructions
    # CCMP (register) -- A64
    # Conditional Compare (register)
    # CCMP  <Wn>, <Wm>, #<nzcv>, <cond>
    # CCMP  <Xn>, <Xm>, #<nzcv>, <cond>
    class CCMP_reg < Instruction
      def initialize rn, rm, nzcv, cond, sf
        @rn   = rn
        @rm   = rm
        @nzcv = nzcv
        @cond = cond
        @sf   = sf
      end

      def encode
        CCMP_reg(@sf, @rm, @cond, @rn, @nzcv)
      end

      private

      def CCMP_reg sf, rm, cond, rn, nzcv
        insn = 0b0_1_1_11010010_00000_0000_0_0_00000_0_0000
        insn |= ((apply_mask(sf, 0x1)) << 31)
        insn |= ((apply_mask(rm, 0x1f)) << 16)
        insn |= ((apply_mask(cond, 0xf)) << 12)
        insn |= ((apply_mask(rn, 0x1f)) << 5)
        insn |= (apply_mask(nzcv, 0xf))
        insn
      end
    end
  end
end
