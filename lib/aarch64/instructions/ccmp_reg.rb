module AArch64
  module Instructions
    # CCMP (register) -- A64
    # Conditional Compare (register)
    # CCMP  <Wn>, <Wm>, #<nzcv>, <cond>
    # CCMP  <Xn>, <Xm>, #<nzcv>, <cond>
    class CCMP_reg < Instruction
      def initialize rn, rm, nzcv, cond, sf
        @rn   = check_mask(rn, 0x1f)
        @rm   = check_mask(rm, 0x1f)
        @nzcv = check_mask(nzcv, 0x0f)
        @cond = check_mask(cond, 0x0f)
        @sf   = check_mask(sf, 0x01)
      end

      def encode _
        CCMP_reg(@sf, @rm, @cond, @rn, @nzcv)
      end

      private

      def CCMP_reg sf, rm, cond, rn, nzcv
        insn = 0b0_1_1_11010010_00000_0000_0_0_00000_0_0000
        insn |= ((sf) << 31)
        insn |= ((rm) << 16)
        insn |= ((cond) << 12)
        insn |= ((rn) << 5)
        insn |= (nzcv)
        insn
      end
    end
  end
end
