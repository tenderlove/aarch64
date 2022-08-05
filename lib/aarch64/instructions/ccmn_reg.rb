module AArch64
  module Instructions
    # CCMN (register) -- A64
    # Conditional Compare Negative (register)
    # CCMN  <Wn>, <Wm>, #<nzcv>, <cond>
    # CCMN  <Xn>, <Xm>, #<nzcv>, <cond>
    class CCMN_reg < Instruction
      def initialize rn, rm, nzcv, cond, sf
        @rn   = check_mask(rn, 0x1f)
        @rm   = check_mask(rm, 0x1f)
        @nzcv = check_mask(nzcv, 0x0f)
        @cond = check_mask(cond, 0x0f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode
        CCMN_reg(@sf, @rm, @cond, @rn, @nzcv)
      end

      private

      def CCMN_reg sf, rm, cond, rn, nzcv
        insn = 0b0_0_1_11010010_00000_0000_0_0_00000_0_0000
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
